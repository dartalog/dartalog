// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_browse_page.html")
library dartalog.client.pages.item_browse_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:polymer_elements/iron_list.dart';
import 'package:polymer_elements/iron_flex_layout.dart';


import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/controls/item_add/item_add_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/tools.dart';

import '../../api/dartalog.dart' as API;

@PolymerRegister('item-browse-page')
class ItemBrowsePage extends APage with ARefreshablePage, ASearchablePage {
  static final Logger _log = new Logger("ItemBrowsePage");
  Logger get loggerImpl => _log;

  @Property(notify: true)
  List<ItemListing> itemsList = new List<ItemListing>();

  @property
  bool noItemsFound = false;

  ItemAddControl get browseItemAddControl =>  $['browse_item_add_control'];

  ItemBrowsePage.created() : super.created("Item Browse");

  String _currentQuery = "";
  bool _loaded = false;

  @property
  bool showAddControl = false;

  @override
  Future activateInternal(Map args, [bool forceRefresh = false]) async {
    set("showAddControl",userHasPrivilege(dartalog.UserPrivilege.curator));
    if(showAddControl) {
      await browseItemAddControl.activate(this.api,args);
    }
    if(args.containsKey(ROUTE_ARG_SEARCH_QUERY_NAME)) {
      if(_currentQuery!=args[ROUTE_ARG_SEARCH_QUERY_NAME].toString().trim()) {
        _currentQuery = args[ROUTE_ARG_SEARCH_QUERY_NAME].toString().trim();
        if(isNullOrWhitespace(this.mainApp.searchText))
          this.mainApp.setSearchText(_currentQuery);
        await this.refresh();
      } else if(!_loaded||forceRefresh) {
        await this.refresh();
      }
    } else if(!_loaded||forceRefresh) {
      await this.refresh();
    }
  }

  @override
  Future refresh() async {
    await loadItems();
  }

  @override
  Future newItem() async {
    browseItemAddControl.start();
  }

  Future loadItems() async {
    await handleApiExceptions(() async {
      _loaded = false;
      clear("itemsList");
      set("noItemsFound", false);
      dynamic data;
      if(isNullOrWhitespace(_currentQuery)) {
        data = await api.items.getVisibleListings();
      } else {
        data = await api.items.searchVisible(_currentQuery);
      }
      set("itemsList", ItemListing.convertList(data));
      set("noItemsFound", itemsList.length==0);
      _loaded = true;
    });
  }

  @override
  Future search(String query) async {
    if(isNullOrWhitespace(query)) {
      _loaded = false;
      _currentQuery = "";
      this.mainApp.activateRoute(BROWSE_ROUTE_PATH);
    } else {
      this.mainApp.activateRoute(SEARCH_ROUTE_PATH, arguments: {ROUTE_ARG_SEARCH_QUERY_NAME: query});
    }
  }

  @reflectable
  itemClicked(event, [_]) async {
    try {
      dynamic ele = getParentElement(event.target, "paper-card");
      String id = ele.dataset["id"];
      if(isNullOrWhitespace(id))
        return;

      mainApp.activateRoute(ITEM_VIEW_ROUTE_PATH, arguments: {ROUTE_ARG_ITEM_ID_NAME: id});
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @reflectable
  String getThumbnailForImage(String value) {
    return getImageUrl(value, ImageType.THUMBNAIL);
  }
}