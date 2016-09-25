// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code
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
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';
import 'package:dartalog/client/controls/barcode_scanner/barcode_scanner.dart';

@PolymerRegister('item-import-page')
class ItemImportPage extends APage with ASaveablePage {
  static final Logger _log = new Logger("ItemImportPage");
  Logger get loggerImpl => _log;

  @Property(notify: true)
  String currentTab = "single_import_tab";

  @Property(notify: true)
  String selectedImportSource = "amazon";
  @Property(notify: true)
  String selectedCollectionId;

  @Property(notify: true)
  List<IdNamePair> collections = new List<IdNamePair>();

  @property
  String searchQuery = "";
  @property
  String bulkSearchQuery = "";

  @Property(notify: true)
  List<ImportSearchResult> results = new List<ImportSearchResult>();
  @Property(notify: true)
  bool noResults = false;
  @Property(notify: true)
  bool searchFinished = false;


  @Property(notify: true)
  List<BulkImportItem> bulkResults = new List<BulkImportItem>();

  API.ImportResult importResult = null;

  ItemImportPage.created() : super.created("Import Item(s)");

  ItemEditControl get itemEditControl =>
      document.getElementById('item_import_item_edit_control');

  IronPages get singleImportPages => $['single_import_pages'];
  IronPages get bulkImportPages => $['bulk_import_pages'];

  AuthWrapperControl get authWrapper => this.querySelector("auth-wrapper-control");


  @Property(notify: true)
  List<ItemType> itemTypes = [];

  attached() {
    super.attached();
    _loadPage();
  }

  Future _loadPage() async {
    showSaveButton = false;
    showBackButton = false;

    bool authed = await authWrapper.evaluatePageAuthentication();
    if(authed) {
      singleImportPages.selected = "item_search";
      //await loadItemTypes();
      await loadCollections();
      //await itemAddControl.activate(this.api, args);
      _resetSearchFields();
    }
  }

  @reflectable scanSingle(event, [_]) {
    BarcodeScannerControl bsc = this.querySelector("#singleBarcodeScanner");
    bsc.startBarcodeScanner();
  }

  @reflectable
  tabControlClicked(event,[_]) {
    _resetSearchFields();
  }

  @reflectable
  clearClicked(event,[_]) {
    _resetSearchFields();
  }

  void _resetSearchFields() {
    set("searchQuery", "");
    set("bulkSearchQuery", "");
    set("searchFinished", false);
    set("noResults", false);
    clear("results");
    clear("bulkResults");
    switch(this.currentTab) {
      case "single_import_tab":
        $["single_search_input"].focus();
        break;
      case "bulk_import_tab":
        $["bulk_search_input"].focus();
        break;
    }
  }

  @reflectable
  searchKeypress(event, [_]) async {
    if(event.original.charCode==13)
      await performSingleSearch();
  }

  ImportSearchResult getSearchResult(String id) {
    for (ImportSearchResult result in this.results) {
      if (result.id == id) {
        return result;
      }
    }
    return null;
  }

  Future loadCollections() async {
    await handleApiExceptions(() async {
      clear("collections");
      API.ListOfIdNamePair data = await api.collections.getAllIdsAndNames();
      addAll("collections", IdNamePair.copyList(data));
    });
  }

  Future loadItemTypes() async {
    await handleApiExceptions(() async {
      clear("itemTypes");
      API.ListOfIdNamePair data = await api.itemTypes.getAllIdsAndNames();
      addAll("itemTypes", IdNamePair.copyList(data));
    });
  }


  @override
  Future save() async {
    String id = await itemEditControl.save();
    if(!isNullOrWhitespace(id)) {
      showMessage("Item added");
      window.location.hash = "item/${id}";
    }
  }

  @reflectable
  singleSearchClicked(event, [_]) async {
    performSingleSearch();
  }

  Future performSingleSearch() async {
    set("searchFinished", false);
    set("noResults", false);
    await handleApiExceptions(() async {
      try {
        this.startLoading();
        clear("results");

        API.SearchResults results =
        await api.import.search(selectedImportSource, this.searchQuery);
        addAll("results", ImportSearchResult.convertList(results.results));
        set("noResults", this.results.isEmpty);
        set("searchFinished", true);
      }finally {
        this.stopLoading();
      }
    });
  }

  @reflectable
  searchResultClicked(event, [_]) async {
    await handleApiExceptions(() async {

      dynamic ele = getParentElement(event.target, "paper-item");
      String id = ele.dataset["id"];
      API.ImportResult result = await api.import.import(selectedImportSource, id);
      importResult = result;

      await itemEditControl.loadImportResult(result);

      this.showSaveButton = true;
      this.showBackButton = true;
      singleImportPages.selected = "item_entry";
      this.evaluatePage();
    });
  }

  @reflectable
  bulkSearchClicked(event, [_]) async {
    await handleApiExceptions(() async {
      try {
        if (isNullOrWhitespace(selectedImportSource)) {
          throw new Exception("Please select an import source");
        }
        if (isNullOrWhitespace(selectedCollectionId)) {
          throw new Exception("Please select a collection");
        }


        this.startLoading();
        clear("bulkResults");

        if (isNullOrWhitespace(bulkSearchQuery))
          return;

        List<String> lines = bulkSearchQuery.split("\n");

        for (String line in lines) {
          if (isNullOrWhitespace(line))
            continue;
          API.SearchResults results =
          await api.import.search(selectedImportSource, line);

          BulkImportItem bii = new BulkImportItem(
              line, ImportSearchResult.convertList(results.results));

          add("bulkResults", bii);
        }
      } finally {
        this.stopLoading();
      }
    });
  }

  @reflectable
  bulkImportSaveClicked(event, [_]) async {
    await handleApiExceptions(() async {
      try {
        this.startLoading();


        for (int i = 0; i < this.bulkResults.length; i++) {
          BulkImportItem bii = this.bulkResults[i];
          if (!bii.selected)
            continue;

          Item newItem;
          if (bii.newItem != null) {
            newItem = bii.newItem;
          } else {
            API.ImportResult result = await api.import.import(
                selectedImportSource, bii.selectedResult);

            if (isNullOrWhitespace(result.itemTypeId))
              throw new Exception("Was not able to determine item type for ${bii
                  .selectedResult}, please perform a single import of this item");

            API.ItemType itemType = await api.itemTypes.getById(
                result.itemTypeId, includeFields: true);

            if (itemType == null)
              throw new Exception("Detected item type for ${bii
                  .selectedResult} does not exist on server, please perform a single import of this item");


            newItem = new Item.forType(new ItemType.copy(itemType));
            newItem.applyImportResult(result);
          }

          API.CreateItemRequest request = new API.CreateItemRequest();
          request.item = new API.Item();
          newItem.copyTo(request.item);
          request.collectionId = this.selectedCollectionId;
          request.uniqueId = bii.uniqueId;

          await api.items.createItemWithCopy(request);
          removeAt("bulkResults", i);
          i--;
        }
      }finally{
        this.stopLoading();
      }
    });
  }

  @reflectable
  bulkUniqueIdKeyPress(event, [_]) async {
    if(event.original.charCode==13) {
      Element ele = getParentElement(event.target, "paper-input");
      String index = ele.dataset["index"];
      int i = int.parse(index);
      i++;
      PaperInput next = querySelector("paper-input[data-index='${i}']");
      if(next!=null) {
        next.focus();
        //TODO: Figure out a way to select all the text in the input element for easier re-scannings
      }
    }
  }
}
