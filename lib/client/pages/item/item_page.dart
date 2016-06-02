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
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
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
  Logger get loggerImpl => _log;

  @property
  String currentItemId = "";

  @Property(notify: true)
  Item currentItem = new Item();

  ItemPage.created() : super.created("Item View") {
    this.showBackButton = true;
  }

  @Property(notify: true)
  List<Collection> collections = new List<Collection>();

  @Property(notify: true)
  ItemCopy currentItemCopy = new ItemCopy();

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
    await handleApiExceptions(() async {
    API.Item item = await api.items.getById(this.currentItemId,includeType: true, includeFields: true, includeCopies: true );
    Item newItem = new Item.copy(item);
    set("currentItem", newItem);
    set("currentItem.fields",newItem.fields);
    set("currentItem.copies",newItem.copies);
    setTitle(newItem.name);
    });
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

  _updateCurrentItem(ItemCopy itemCopy) {
    set("currentItemCopy", itemCopy);
    //itemCopy.
  }

  @property
  bool createCopy = false;


  @reflectable
  addCartCopyClicked(event, [_]) async {
    await handleApiExceptions(() async {
      dynamic ele = getParentElement(event.target, "paper-item");
      String copy = ele.dataset["copy"];
      API.ItemCopy itemCopy = await api.items.copies.get(this.currentItem.id, int.parse(copy));
      this.mainApp.addToCart(new ItemCopy.copyFrom(itemCopy));
    });
  }

  @reflectable
  addCopyClicked(event, [_]) async {
    if(!await loadAvailableCollections())
      return;
    clearValidation();
    set("currentItemCopy", new ItemCopy());
    set("createCopy", true);
    $['copyEditDialog'].open();
  }

  @reflectable
  editItemCopyClicked(event, [_]) async {
    if(!await loadAvailableCollections())
      return;
    await handleApiExceptions(() async {
      clearValidation();
      dynamic ele = getParentElement(event.target, "paper-item");
      String copy = ele.dataset["copy"];
      API.ItemCopy newCopy = await api.items.copies.get(
          this.currentItem.id, int.parse(copy));
      set("currentItemCopy", new ItemCopy.copyFrom(newCopy));
      set("createCopy", false);
      $['copyEditDialog'].open();
    });
  }


  @reflectable
  saveItemCopyClicked(event, [_]) async {
    await handleApiExceptions(() async {
      API.ItemCopy newCopy = new API.ItemCopy();
      this.currentItemCopy.copyTo(newCopy);
      if (createCopy)
        await api.items.copies.create(newCopy, this.currentItem.id);
      else
        await api.items.copies.update(
            newCopy, this.currentItem.id, this.currentItemCopy.copy);
      showMessage("Copy saved");
      $['copyEditDialog'].close();
      this.refresh();
    });
  }

  Future<bool> loadAvailableCollections() async {
    bool output = await handleApiExceptions(() async {
      clear("collections");

      API.ListOfIdNamePair data = await api.collections.getAllIdsAndNames();

      if(data.length==0)
        throw new Exception("No collections defined");

      set("collections", IdNamePair.convertList(data));
      return true;
    });
    if(output==true)
      return true;
    return false;
  }
}