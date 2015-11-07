// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("template_admin_page.html")
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

/// A Polymer `<template-admin-page>` element.
@CustomTag('template-admin-page')
class TemplateAdminPage extends APage {
  static final Logger _log = new Logger("TemplateAdminPage");

  Map fields = new ObservableMap();

  /// Constructor used to create instance of MainApp.
  TemplateAdminPage.created() : super.created();

  @published String current_uuid;
  @published String current_name;
  @published String current_type;
  @published String current_format;

  Map<String,String> get FIELD_TYPES => dartalog.FIELD_TYPES;

  @override
  void init(API.DartalogApi api) {
    super.init(api);
    this.supportsAdding = true;
    this.title = "Property Admin";
    loadProperties();
  }

  Future loadProperties() async {
    try {
    fields.clear();

    API.MapOfField data = await api.fields.getAll();

    fields.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }

  @override
  addItem() {
  }

  fieldClicked(event, detail, target) async {
    try {
      String id = target.dataset["id"];
      API.Field field = this.fields[id];

      this.current_format = field.format;
      this.current_name = field.name;
      this.current_type = field.type;
      this.current_uuid = id;
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  validateField(event, detail, target) {
    _log.info("Validating");
  }

  clearClicked(event, detail, target) async {
  this.current_uuid = null;
    this.current_format = "";
    this.current_type = "";
    this.current_name ="";
  }
  saveClicked(event, detail, target) async {
    try {

      API.Field field = new API.Field();
      field.name = this.current_name;
      field.type = this.current_type;
      field.format = this.current_format;

      if(this.current_uuid==null) {
        await this.api.fields.create(field);
      } else {
        await this.api.fields.update(field, this.current_uuid);
      }
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    } finally {
      loadProperties();
    }

  }

}