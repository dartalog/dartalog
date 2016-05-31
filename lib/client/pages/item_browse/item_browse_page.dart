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
import 'package:polymer_elements/iron_flex_layout.dart';


import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/controls/item_add/item_add_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/tools.dart';

import '../../api/dartalog.dart' as API;

@PolymerRegister('item-browse-page')
class ItemBrowsePage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("ItemBrowsePage");

  @Property(notify: true)
  List<Item> itemsList = new List<Item>();

  ItemAddControl get browseItemAddControl =>  $['browse_item_add_control'];

  ItemBrowsePage.created() : super.created("Item Browse");

  @override
  Future activateInternal(Map args) async {
    await browseItemAddControl.activate(this.api,null);
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
    try {
      clear("itemsList");
      dynamic data = await api.items.getAllListings();
      set("itemsList", ItemListing.convertList(data));
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
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

}