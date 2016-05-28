// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_add_page.html")
library dartalog.client.pages.item_add_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_pages.dart';

import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/controls/item_edit/item_edit_control.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

/// A Polymer `<template-admin-page>` element.
@PolymerRegister('item-add-page')
class ItemAddPage extends APage with ASaveablePage {
  static final Logger _log = new Logger("ItemAddPage");

  String currentItemTypeId = "";

  ItemAddPage.created() : super.created("Add Item");

  ItemEditControl get itemAddControl => document.getElementById('item_add_page_edit_control');

  @override
  Future activateInternal(Map args) async {
    if(isNullOrWhitespace(args[ROUTE_ARG_ITEM_TYPE_ID_NAME])) {
      throw new Exception("{$ROUTE_ARG_ITEM_TYPE_ID_NAME} is required");
    }
    this.currentItemTypeId = args[ROUTE_ARG_ITEM_TYPE_ID_NAME];

    await itemAddControl.activate(this.api, args);
  }

  @override
  Future save() async {
    String id = await itemAddControl.save();
    if(!isNullOrWhitespace(id)) {
      showMessage("Item created succesfully");
      this.mainApp.activateRoute(ITEM_VIEW_ROUTE_PATH, arguments: {ROUTE_ARG_ITEM_ID_NAME: id});
    }

  }





  IronPages get pages => $['item_add_pages'];


  @property
  String searchQuery;

  @Property(notify: true)
  List<ImportSearchResult> results = new List<ImportSearchResult>();



  API.ImportResult importResult = null;

  @reflectable
  String getImportResultValue(String name) {
    if(importResult==null
        ||!importResult.values.containsKey(name)
        ||importResult.values[name].length==0)
      return "";
    return importResult.values[name][0];
  }



  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }

  ImportSearchResult getSearchResult(String id) {
    for(ImportSearchResult result in this.results) {
      if(result.id==id) {
        return result;
      }
    }
    return null;
  }

  @reflectable
  searchClicked(event, [_]) async {
    try {
      clear("results");

      API.SearchResults results =
          await api.import.search("amazon", this.searchQuery);
      for(API.SearchResult sr in results.results) {
        add("results", new ImportSearchResult.copy(sr));
      }

    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @reflectable
  searchResultClicked(event, [_]) async {
    try {
      dynamic ele = getParentElement(event.target,"paper-item");
      String id = ele.dataset["id"];
      API.ImportResult result = await api.import.import("amazon", id);
      importResult = result;
      pages.selected = "choose_type";
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @reflectable
  createClicked(event, [_]) async {
    try {
      dynamic ele = getChildElement($['input_type'],'paper-listbox');

      String value = ele.selected;
      API.ItemType it = await api.itemTypes.get(value, expand: "fields");

      if(it==null)
        throw new Exception("Specified Item Type not found on server");

      Item newItem = new Item.forType(new ItemType.copy(it));

      for(Field field in newItem.fields) {
        field.value = this.getImportResultValue(field.id);
      }

      newItem.name = this.getImportResultValue("name");

      set("currentItem", newItem);
      set("currentItem.fields",newItem.fields);
      set("currentItem.name",newItem.name);

      pages.selected = "item_entry";
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

}
