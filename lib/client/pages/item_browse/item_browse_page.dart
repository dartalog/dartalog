// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code
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
  Map routeData;

  @Property(notify: true)
  Map subRoute;

  @Property(notify: true)
  List<ItemSummary> itemsList = new List<ItemSummary>();

  @property
  bool noItemsFound = false;

  @property
  bool searchActive = false;

  @property
  bool pageRouteActive = false;

  ItemAddControl get browseItemAddControl =>  $['browse_item_add_control'];

  ItemBrowsePage.created() : super.created("Item Browse");

  @property
  bool showAddControl = false;

  attached() {
    super.attached();
    set("showAddControl",userHasPrivilege(dartalog.UserPrivilege.curator));
    this.loadItems();
  }

  @override
  routeChanged() {
    this.loadItems();
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
      try {
        this.startLoading();
        this.currentPage = 1;
        this.searchQuery = EMPTY_STRING;
        if(this.routeData!=null) {
          if (this.routeData.containsKey("page") &&
              !isNullOrWhitespace(this.routeData["page"])&&
              (searchActive||pageRouteActive)) {
            this.currentPage = int.parse(this.routeData["page"]);
          }


          if (this.routeData.containsKey("search") &&
              !isNullOrWhitespace(this.routeData["search"])&&
              searchActive) {
            this.searchQuery = this.routeData["search"];
          }
        }
        clear("itemsList");
        set("noItemsFound", false);
        API.PaginatedResponse data;
        if (isNullOrWhitespace(searchQuery)) {
          data = await api.items.getVisibleSummaries(page: currentPage);
        } else {
          data = await api.items.searchVisible(searchQuery, page: currentPage);
        }

        currentPage = data.page;
        totalPages = data.totalPages;
        set("itemsList", ItemSummary.convertList(data.items));
        set("noItemsFound", itemsList.length == 0);

        this.evaluatePage();
      } finally {
        this.stopLoading();
      }
    });
  }

  @override
  Future search() async {
    if(isNullOrWhitespace(searchQuery)) {
      window.location.hash = "items/page/1";
      //set("routeData.search","");
    } else {
      window.location.hash = "items/search/${searchQuery}/page/1";
      //set("routeData.search",searchQuery);
    }
  }

  @reflectable
  String generateItemLink(String id) {
    return this.generateLink(_generateItemLink(id));
  }

  String _generateItemLink(String id) {
    return "${Pages.ITEM}/${id}";
  }

  @reflectable
  String getThumbnailForImage(String value) {
    return getImageUrl(value, ImageType.THUMBNAIL);
  }





}