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
import 'package:polymer_elements/paper_menu.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:polymer_elements/iron_list.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_flex_layout.dart';


import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/controls/item_add/item_add_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/tools.dart';

import '../../api/dartalog.dart' as API;

@PolymerRegister('item-browse-page')
class ItemBrowsePage extends APage with ARefreshablePage, ASearchablePage, ACollectionPage {
  static final Logger _log = new Logger("ItemBrowsePage");
  Logger get loggerImpl => _log;

  @Property(notify: true)
  List<ItemSummary> itemsList = new List<ItemSummary>();

  @property
  bool noItemsFound = false;

  ItemAddControl get browseItemAddControl =>  $['browse_item_add_control'];

  ItemBrowsePage.created() : super.created("Item Browse");

  String _lastSearchQuery = "";

  bool _loaded = false;

  @property
  bool showAddControl = false;

  int lastLoadedPage = -1;

  @override
  Future activateInternal([bool forceRefresh = false]) async {
    set("showAddControl",userHasPrivilege(dartalog.UserPrivilege.curator));
    if(showAddControl) {
      await browseItemAddControl.activate();
    }
    bool refresh = false;
    int requestedPage = 0;

    if(routeParameters!=null) {
      if(routeParameters.containsKey("search")) {
        if(_lastSearchQuery!=routeParameters["search"].toString().trim()) {
          refresh = true;
        } else if(!_loaded||forceRefresh) {
          refresh = true;
        }
      } else if(!_loaded||forceRefresh) {
        refresh = true;
      }

      if(routeParameters.containsKey("page")) {
        requestedPage = int.parse(routeParameters["page"]);
      }
    }

    if(requestedPage!=this.lastLoadedPage) {
      refresh = true;
      currentPage = requestedPage;
    }

    if(refresh)
      await this.refresh();
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
      API.PaginatedResponse data;
      if(isNullOrWhitespace(searchQuery)) {
        data = await api.items.getVisibleSummaries(page: currentPage-1);
      } else {
        data = await api.items.searchVisible(searchQuery, page: currentPage-1);
      }
      lastLoadedPage = data.page+1;
      currentPage =  data.page+1;
      totalPages = data.totalPages;
      set("itemsList", ItemSummary.convertList(data.items));
      set("noItemsFound", itemsList.length==0);

      mainApp.evaluatePage();

      _loaded = true;
    });
  }

  @override
  Future search() async {
    if(isNullOrWhitespace(searchQuery)) {
      _loaded = false;
      set("routeParameters.searchQuery","");
    } else {
      set("routeParameters.searchQuery",searchQuery);
    }
  }

  @reflectable
  generateItemLink(String id) {
    return "#item/${id}";
  }

  @reflectable
  String getThumbnailForImage(String value) {
    return getImageUrl(value, ImageType.THUMBNAIL);
  }





}