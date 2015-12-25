// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_add_page.html")
library dartalog.client.pages.item_add_page;

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
import 'package:core_elements/core_pages.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';

import '../../api/dartalog.dart' as API;

/// A Polymer `<template-admin-page>` element.
@CustomTag('item-add-page')
class ItemAddPage extends APage with ARefreshablePage  {
  static final Logger _log = new Logger("ItemAddPage");

  CorePages get pages => $['item_add_pages'];

  /// Constructor used to create instance of MainApp.
  ItemAddPage.created() : super.created("Item Add");

  @observable Map templates = new ObservableMap();

  @published String templateId;

  @observable Map<String,API.Field> templateFields = new ObservableMap<String,API.Field>();
  @observable Map<String,String> fieldValues = new ObservableMap<String,String>();

  @override
  void init(API.DartalogApi api) {
    super.init(api);
  }

  void activate(Map args) {
    this.refresh();
  }

  @override
  Future refresh() async {
    //this.clear();
    await loadTemplates();
  }

  Future loadTemplates() async {
    try {
      templates.clear();
      templateFields.clear();
      API.MapOfTemplate data = await api.templates.getAll();
      templates.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }


  templateClicked(event, detail, target) async {
    try {
      String id = target.dataset["id"];
      API.Template template = this.templates[id];
      this.fieldValues.clear();
      for(var field in template.fields.keys) {
        this.fieldValues[field] = ""; // SOme day, default values!
      }
      this.templateFields.addAll(template.fields);
      this.templateId = id;
      pages.selected = "field_input";
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  saveClicked(event, detail, target) {
    try {
      if(this.templateId==null) {
        throw new Exception("Template not selected");
      }
      API.Item item = new API.Item();
      item.template = this.templateId;

      item.fieldValues = this.fieldValues;

      api.items.create(item);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  validateField(event, detail, target) {
    _log.info("Validating");
  }

  backClicked(event, detail, target) async {
    this.templateId = "";
    pages.selected = "type_select";
  }


}