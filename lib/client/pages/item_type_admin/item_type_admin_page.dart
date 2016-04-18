// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_type_admin_page.html")
library dartalog.client.pages.template_admin_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_action_dialog.dart';
import 'package:paper_elements/paper_shadow.dart';
import 'package:paper_elements/paper_item.dart';
import 'package:paper_elements/paper_dropdown.dart';
import 'package:paper_elements/paper_dropdown_menu.dart';
import 'package:core_elements/core_selector.dart';
import 'package:core_elements/core_menu.dart';


import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';

import '../../api/dartalog.dart' as API;
import '../../../tools.dart';

/// A Polymer `<template-admin-page>` element.
@CustomTag('template-admin-page')
class TemplateAdminPage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("TemplateAdminPage");

  Map fields = new ObservableMap();

  /// Constructor used to create instance of MainApp.
  TemplateAdminPage.created() : super.created( "Template Admin");

  @observable Map itemTypes = new ObservableMap();
  @observable Map availableFields = new ObservableMap();

  @published String currentId;
  @published String currentName;
  @published List currentFields = new ObservableList();

  CoreMenu get fieldDropdown=> $['field_dropdown'];

  void activateInternal(Map args) {
    this.refresh();
  }


  Future refresh() async {
    this.clear();
    await loadAvailableFields();
    await loadTemplates();
  }

  Future loadAvailableFields() async {
    try {
      availableFields.clear();
      API.MapOfField data = await api.fields.getAll();
      availableFields.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  Future loadTemplates() async {
    try {
      itemTypes.clear();
      API.MapOfItemType data = await api.itemTypes.getAll();
      itemTypes.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  void clear() {
    this.currentId = null;
    this.currentName ="";
    this.currentFields .clear();
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }


  templateClicked(event, detail, target) async {
    try {
      String id = target.dataset["id"];
      API.ItemType itemType = this.itemTypes[id];

      this.currentId = id;
      this.currentName = itemType.name;
      this.currentFields.clear();
      this.currentFields.addAll(itemType.fields);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  addFieldClicked(event, detail, target) async {
    try {
      String id = this.fieldDropdown.selected;

      if(isNullOrWhitespace(id))
        throw new Exception("Please select a field");

      if(!this.availableFields.containsKey(id))
        throw new Exception("Invalid field selected: ${id}");

      if(currentFields.contains(id)){
        throw new Exception("Field has already been added");
      }

      currentFields.add(id);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }
  validateField(event, detail, target) {
    _log.info("Validating");
  }

  clearClicked(event, detail, target) async {
    this.clear();
  }
  saveClicked(event, detail, target) async {
    try {

      API.ItemType itemType = new API.ItemType();

      itemType.name = this.currentName;
      itemType.fields = new List<String>();
      for(String field_id in this.currentFields) {
        if(!this.availableFields.containsKey(field_id)) {
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
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    } finally {
    }

  }

}