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

import '../../api/dartalog.dart' as API;
import '../../../tools.dart';

/// A Polymer `<template-admin-page>` element.
@PolymerRegister('item-type-admin-page')
class ItemTypeAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("ItemTypeAdminPage");


  /// Constructor used to create instance of MainApp.
  ItemTypeAdminPage.created() : super.created( "Item Type Admin");

  Map<String,API.ItemType> itemTypes = new Map<String,API.ItemType>();
  @Property(notify: true)
  List itemTypeIds = new List();
  @reflectable String getItemTypeName(String key) => itemTypes[key].name;


  Map fields = new Map();
  @Property(notify: true)
  List fieldIds = new List();
  @reflectable String getFieldName(String key) => fields[key].name;

  @property String selectedType;

  @property String currentId;
  @property String currentName;
  @property List currentFields = new List();

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
      clear("fieldIds");
      fields.clear();

      API.MapOfField data = await api.fields.getAll();

      fields.addAll(data);
      addAll("fieldIds", fields.keys);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  Future loadItemTypes() async {
    try {
      clear("itemTypeIds");
      itemTypes.clear();
      API.MapOfItemType data = await api.itemTypes.getAll();
      itemTypes.addAll(data);
      addAll("itemTypeIds", itemTypes.keys);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  void reset() {
    set("currentId", null);
    set("currentName", "");
    clear("currentFields");
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

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }

  @reflectable
  itemTypeClicked(event, [_]) async {
    try {
      String id = event.target.dataset["id"];
      API.ItemType itemType = this.itemTypes[id];

      set("currentId", id);
      set("currentName", itemType.name);
      clear("currentFields");
      addAll("currentFields",itemType.fields);
      editDialog.open();
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  @reflectable
  Future addFieldClicked(event, [_]) async {
    try {
      String id = this.selectedType;

      if(isNullOrWhitespace(id))
        throw new Exception("Please select a field");

      if(!this.fields.containsKey(id))
        throw new Exception("Invalid field selected: ${id}");

      if(currentFields.contains(id)){
        throw new Exception("Field has already been added");
      }

      add("currentFields",id);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }
  @reflectable
  Future deleteClicked(event, [_]) async {
    try {
      dynamic ele = event.target;
      while(isNullOrWhitespace(ele.dataset["id"])) {
        ele = ele.parent;
      }
      String id = ele.dataset["id"];


      if(id==null){
        throw new Exception("null id");
      }
      removeItem("currentFields", id);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }

  }

  @reflectable
  saveClicked(event, [_]) async {
    try {

      API.ItemType itemType = new API.ItemType();

      itemType.name = this.currentName;
      itemType.fields = new List<String>();
      for(String field_id in this.currentFields) {
        if(!this.fields.containsKey(field_id)) {
          throw new Exception("Field not found: ${field_id}");
        }
        itemType.fields.add(field_id);
      }

      if(this.currentId==null) {
        await this.api.itemTypes.create(itemType);
      } else {
        await this.api.itemTypes.update(itemType, this.currentId);
      }
      this.refresh();
      this.editDialog.close();
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    } finally {
    }

  }

}