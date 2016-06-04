// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_import_page.html")
library dartalog.client.pages.item_import_page;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/api/dartalog.dart' as API;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/item_edit/item_edit_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_tab.dart';
import 'package:polymer_elements/paper_tabs.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_toggle_button.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_textarea.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:web_components/web_components.dart';

/// A Polymer `<template-admin-page>` element.
@PolymerRegister('item-import-page')
class ItemImportPage extends APage with ASaveablePage {
  static final Logger _log = new Logger("ItemImportPage");
  Logger get loggerImpl => _log;

  @Property(notify: true)
  String selectedImportSource = "amazon";

  @Property(notify: true)
  List<IdNamePair> itemTypes = new List<IdNamePair>();

  @property
  String searchQuery = "";
  @property
  String bulkSearchQuery = "";

  @Property(notify: true)
  List<ImportSearchResult> results = new List<ImportSearchResult>();

  @Property(notify: true)
  bool bulkMode= false;

  @Property(notify: true)
  String selectedItemType = "";


  API.ImportResult importResult = null;

  ItemImportPage.created() : super.created("Import Item");

  ItemEditControl get itemEditControl =>
      document.getElementById('item_import_item_edit_control');

  IronPages get pages => $['item_add_pages'];
  PaperDropdownMenu get itemTypeDropDown => $['item_type_dropdown'];

  @override
  Future activateInternal(Map args) async {
    showSaveButton = false;
    pages.selected = "item_search";
    await loadItemTypes();
    //await itemAddControl.activate(this.api, args);
  }


  @reflectable
  searchKeypress(event, [_]) async {
    if(event.original.charCode==13)
      await performSearch();
  }

  @reflectable
  String getImportResultValue(String name) {
    if (importResult == null ||
        !importResult.values.containsKey(name) ||
        importResult.values[name].length == 0) return "";
    return importResult.values[name][0];
  }

  ImportSearchResult getSearchResult(String id) {
    for (ImportSearchResult result in this.results) {
      if (result.id == id) {
        return result;
      }
    }
    return null;
  }

  Future loadItemTypes() async {
    try {
      clear("itemTypes");
      API.ListOfIdNamePair data = await api.itemTypes.getAllIdsAndNames();
      addAll("itemTypes", IdNamePair.convertList(data));
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e, st);
    }
  }

  @override
  Future save() async {
    String id = await itemEditControl.save();
    if(!isNullOrWhitespace(id)) {
      showMessage("Item created");
      this.mainApp.activateRoute(ITEM_VIEW_ROUTE_PATH, arguments: {ROUTE_ARG_ITEM_ID_NAME: id});
    }
  }

  @reflectable
  searchClicked(event, [_]) async {
    performSearch();
  }

  Future performSearch() async {
    try {
      clear("results");

      API.SearchResults results =
          await api.import.search(selectedImportSource, this.searchQuery);
      for (API.SearchResult sr in results.results) {
        add("results", new ImportSearchResult.copy(sr));
      }
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e, st);
    }
  }

  @reflectable
  searchResultClicked(event, [_]) async {
    try {
      if(isNullOrWhitespace(selectedItemType)) {
        throw new Exception("Please select an item type");
      }

        dynamic ele = getParentElement(event.target, "paper-item");
      String id = ele.dataset["id"];
      API.ImportResult result = await api.import.import("amazon", id);
      importResult = result;

      API.ItemType it = await api.itemTypes.getById(selectedItemType, includeFields: true);

      if (it == null)
        throw new Exception("Specified Item Type not found on server");


      Item newItem = new Item.forType(new ItemType.copy(it));

      for (Field field in newItem.fields) {
        field.value = this.getImportResultValue(field.id);
      }

      newItem.name = this.getImportResultValue("name");


      await itemEditControl.activate(this.api, {"imported_item": newItem});

      this.showSaveButton = true;
      pages.selected = "item_entry";
      this.mainApp.evaluatePage();
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e, st);
    }
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }
}
