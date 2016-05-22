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
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

/// A Polymer `<template-admin-page>` element.
@PolymerRegister('item-add-page')
class ItemAddPage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("ItemAddPage");

  IronPages get pages => $['item_add_pages'];

  /// Constructor used to create instance of MainApp.
  ItemAddPage.created() : super.created("Item Add");

//  @observable Map itemTypes = new ObservableMap();
//
  @property
  String searchQuery;
  @property
  String templateId;

  @Property(notify: true)
  List<ImportSearchResult> results = new List<ImportSearchResult>();

  @Property(notify: true)
  List<ItemType> itemTypes= new List<ItemType>();

  @property
  ItemType currentItemType = null;

  @Property(notify: true)
  List<Field> itemTypeFields= new List<Field>();

  API.ImportResult importResult = null;

  @reflectable
  String getImportResultValue(String name) {
    if(importResult==null
        ||!importResult.values.containsKey(name)
        ||importResult.values[name].length==0)
      return "";
    return importResult.values[name][0];
  }

  void activateInternal(Map args) {
    this.refresh();
  }

  @override
  Future refresh() async {
    //this.clear();
    pages.selected = "import_item";
    await loadItemTypes();
  }

  Future loadItemTypes() async {
    try {
      clear("itemTypes");
      API.ListOfItemType data = await api.itemTypes.getAll();
      addAll("itemTypes", ItemType.convertList(data));
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
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
      dynamic ele = $['input_type'];
      String value = ele.value;
      ItemType it;
      for(ItemType a in this.itemTypes) {
        if(a.id==value) {
          it = a;
        }
      }
      if(it==null)
        return;

      set("currentItemType", it);


      API.Field field = await api.fields.get(value);


      API.ImportResult result = await api.import.import("amazon", id);
      importResult = result;
      pages.selected = "choose_type";
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

}
