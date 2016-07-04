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
class ItemBrowsePage extends APage with ARefreshablePage, ASearchablePage {
  static final Logger _log = new Logger("ItemBrowsePage");
  Logger get loggerImpl => _log;

  @Property(notify: true)
  List<ItemSummary> itemsList = new List<ItemSummary>();

  @property
  bool noItemsFound = false;

  ItemAddControl get browseItemAddControl =>  $['browse_item_add_control'];

  ItemBrowsePage.created() : super.created("Item Browse");

  String _currentQuery = "";
  bool _loaded = false;

  @property
  bool showPaginator = false;
  @property
  bool enableNextPage = false;
  @property
  bool enablePreviousPage = false;

  @property
  bool showAddControl = false;

  int lastLoadedPage = -1;

  @property
  int currentPage = 0;
  @property
  int totalPages = 1;

  @property
  List<int> availablePages = new List<int>();

  @reflectable
  bool isCurrentPage(int page) => page == currentPage;

  @override
  Future activateInternal(Map args, [bool forceRefresh = false]) async {
    set("showAddControl",userHasPrivilege(dartalog.UserPrivilege.curator));
    if(showAddControl) {
      await browseItemAddControl.activate(this.api,args);
    }
    bool refresh = false;

    if(args.containsKey(ROUTE_ARG_SEARCH_QUERY_NAME)) {
      if(_currentQuery!=args[ROUTE_ARG_SEARCH_QUERY_NAME].toString().trim()) {
        _currentQuery = args[ROUTE_ARG_SEARCH_QUERY_NAME].toString().trim();
        if(isNullOrWhitespace(this.mainApp.searchText))
          this.mainApp.setSearchText(_currentQuery);
        refresh = true;
      } else if(!_loaded||forceRefresh) {
        refresh = true;
      }
    } else if(!_loaded||forceRefresh) {
      refresh = true;
    }

    int requestedPage = 0;
    if(args.containsKey(ROUTE_ARG_PAGE_NAME)) {
      requestedPage = int.parse(args[ROUTE_ARG_PAGE_NAME]);
    }
    if(requestedPage!=this.lastLoadedPage) {
      refresh = true;
      set("currentPage", requestedPage);
    }

    if(refresh)
      await this.refresh();
  }

  void _refreshPaginator() {
    set("showPaginator", totalPages>1);
    if(!showPaginator)
      return;

    clear("availablePages");
    for(int i = 0; i < totalPages; i++) {
      add("availablePages", i+1);
    }

    set("enablePreviousPage",this.currentPage>0);
    set("enableNextPage",this.currentPage<this.totalPages-1);
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
      if(isNullOrWhitespace(_currentQuery)) {
        data = await api.items.getVisibleSummaries(page: currentPage);
      } else {
        data = await api.items.searchVisible(_currentQuery, page: currentPage);
      }
      lastLoadedPage = data.page;
      set("currentPage", data.page);
      set("totalPages", data.totalPages);
      set("itemsList", ItemSummary.convertList(data.items));
      set("noItemsFound", itemsList.length==0);

      _refreshPaginator();

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
  generateItemLink(String id) {
    return "#view/${id}";
  }

  @reflectable
  itemClicked(event, [_]) async {
    try {
      dynamic ele = getParentElement(event.target, "paper-material");
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

  @reflectable
  void nextPage(event, [_]) {
    if(this.currentPage<this.totalPages-1) {
      _activatePage(this.currentPage+1);
    }
  }

  @reflectable
  void previousPage(event, [_]) {
    if(this.currentPage>0) {
      _activatePage(this.currentPage-1);
    }
  }

  @reflectable
  void pageSelected(event, [_]) {
    _activatePage(currentPage);
  }

  void _activatePage(int page) {
    if(isNullOrWhitespace(this._currentQuery)) {
      mainApp.activateRoute(BROWSE_ROUTE_PATH, arguments: {ROUTE_ARG_PAGE_NAME: page});
    }
  }
}