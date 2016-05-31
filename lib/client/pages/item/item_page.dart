// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_page.html")
library dartalog.client.pages.item_page;

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
import 'package:polymer_elements/iron_flex_layout.dart';


import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/tools.dart';

import '../../api/dartalog.dart' as API;

@PolymerRegister('item-page')
class ItemPage extends APage with ARefreshablePage, ADeletablePage, AEditablePage, ASubPage {
  static final Logger _log = new Logger("ItemPage");

  String currentItemId = "";

  @Property(notify: true)
  Item currentItem = new Item();

  ItemPage.created() : super.created("Item View") {
    this.showBackButton = true;
  }

  @override
  Future activateInternal(Map args) async {
    if(isNullOrWhitespace(args[ROUTE_ARG_ITEM_ID_NAME])) {
      throw new Exception("${ROUTE_ARG_ITEM_ID_NAME} is required");
    }
    this.currentItemId = args[ROUTE_ARG_ITEM_ID_NAME];
    await this.refresh();
  }

  @override
  Future goBack() async {
    this.mainApp.activateRoute(BROWSE_ROUTE_PATH);
  }

  @override
  Future refresh() async {
    await loadItem();
  }

  Future loadItem() async {
    try {
      API.Item item = await api.items.getById(this.currentItemId,includeType: true, includeFields: true );
      Item newItem = new Item.copy(item);
      set("currentItem", newItem);
      set("currentItem.fields",newItem.fields);
      setTitle(newItem.name);
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @override
  Future delete() async {
    try {
      if(!window.confirm("Are you sure you want to delete this item?"))
        return;
      await api.items.delete(currentItem.id);
      showMessage("Item deleted");
      mainApp.activateRoute(BROWSE_ROUTE_NAME);
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @override
  Future edit() async {
    try {
      mainApp.activateRoute(ITEM_EDIT_ROUTE_PATH, arguments: {ROUTE_ARG_ITEM_ID_NAME: currentItemId});
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }


}