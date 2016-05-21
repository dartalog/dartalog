// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_type_admin_page.html")
library dartalog.client.pages.template_admin_page;

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
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;
import 'package:dartalog/tools.dart';

/// A Polymer `<template-admin-page>` element.
@PolymerRegister('item-type-admin-page')
class ItemTypeAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("ItemTypeAdminPage");

  ItemTypeAdminPage.created() : super.created( "Item Type Admin");

  @Property(notify: true)
  List<ItemType> itemTypes = new List<ItemType>();

  @Property(notify: true)
  List<Field> fields = new List<Field>();

  @property ItemType currentItemType = new ItemType();
  String currentItemId = "";

  @property String selectedField = "";

  PaperDialog get editDialog =>  $['editDialog'];

  void activateInternal(Map args) {
    this.refresh();
  }

  Future refresh() async {
    this.reset();
    await loadAvailableFields();
    await loadItemTypes();
  }

  Future loadAvailableFields() async {
    try {
      clear("fields");

      API.ListOfField data = await api.fields.getAll();

      for(API.Field f in data) {
        add("fields", new Field.copy(f));
      }
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  Future loadItemTypes() async {
    try {
      clear("itemTypes");
      API.ListOfItemType data = await api.itemTypes.getAll();
      for(API.ItemType it in data) {
        add("itemTypes", new ItemType.copy(it));
      }
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  void reset() {
    set("currentItemType", new ItemType());
    currentItemId = "";
    clearValidation();
  }

  Field getField(String id) {
    for(Field f in this.fields) {
      if(f.id == id)
        return f;
    }
    return null;
  }

  ItemType getItemType(String id) {
    for(ItemType it in this.itemTypes) {
      if(it.id == id)
        return it;
    }
    return null;
  }

  @override
  void clearValidation() {
    $['input_id'].invalid = false;
    $['input_name'].invalid = false;
    $['input_fields'].invalid = false;
    $['output_error'].text = "";
  }

  @override
  Future newItem() async {
    try {
      this.reset();
      editDialog.open();
    } catch (e, st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  @reflectable
  cancelClicked(event, [_]) {
    editDialog.cancel();
    this.reset();
  }

  @reflectable
  itemTypeClicked(event, [_]) async {
    try {
      String id = event.target.dataset["id"];
      ItemType itemType = this.getItemType(id);

      if(itemType==null)
        return;

      currentItemId = id;
      set("currentItemType", new ItemType.copy(itemType));
      editDialog.open();
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  @reflectable
  Future addFieldClicked(event, [_]) async {
    try {
      String id = this.selectedField;

      if(isNullOrWhitespace(id))
        throw new Exception("Please select a field");

      if(this.currentItemType.fields.contains(id)){
        throw new Exception("Field has already been added");
      }

      Field f = this.getField(id);
      if(f==null)
        throw new Exception("Invalid field selected: ${id}");


      add("currentItemType.fields",id);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }
  @reflectable
  Future removeFieldClicked(event, [_]) async {
    try {
      dynamic ele = event.target;
      while(isNullOrWhitespace(ele.dataset["id"])) {
        ele = ele.parent;
      }
      String id = ele.dataset["id"];

      if(id==null){
        throw new Exception("null id");
      }

      removeItem("currentItemType.fields", id);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }

  }

  @reflectable
  saveClicked(event, [_]) async {
    try {
      API.ItemType itemType = new API.ItemType();
      this.currentItemType.copyTo(itemType);

      if(isNullOrWhitespace(this.currentItemId)) {
        await this.api.itemTypes.create(itemType);
      } else {
        await this.api.itemTypes.update(itemType, this.currentItemId);
      }
      this.refresh();
      this.editDialog.close();
    } on API.DetailedApiRequestError catch  ( e, st) {
      try {
        handleApiError(e, generalErrorField: "output_error");
      } catch (e, st) {
        _log.severe(e, st);
        window.alert(e.toString());
      }
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    } finally {
    }

  }

}