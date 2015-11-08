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
class TemplateAdminPage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("TemplateAdminPage");

  Map fields = new ObservableMap();

  /// Constructor used to create instance of MainApp.
  TemplateAdminPage.created() : super.created();

  @observable Map templates = new ObservableMap();
  @observable Map available_fields = new ObservableMap();

  @published String current_id;
  @published String current_name;
  @published List<String> current_fields = new ObservableList();

  @override
  void init(API.DartalogApi api) {
    super.init(api);
    this.title = "Template Admin";
    this.refresh();
  }

  Future refresh() async {
    this.clear();
    await loadAvailableFields();
    await loadTemplates();
  }

  Future loadAvailableFields() async {
    try {
      available_fields.clear();
      API.MapOfField data = await api.fields.getAll();
      available_fields.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  Future loadTemplates() async {
    try {
      templates.clear();
      API.MapOfTemplate data = await api.templates.getAll();
      templates.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  void clear() {
    this.current_id = null;
    this.current_name ="";
    this.current_fields .clear();
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }


  templateClicked(event, detail, target) async {
    try {
      String id = target.dataset["id"];
      API.Template template = this.templates[id];

      this.current_id = id;
      this.current_name = template.name;
      this.current_fields.clear();
      this.current_fields.addAll(template.fields);
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

      API.Template template = new API.Template();

      template.name = this.current_name;
      template.fields = this.current_fields;

      if(this.current_id==null) {
        await this.api.templates.create(template);
      } else {
        await this.api.templates.update(template, this.current_id);
      }
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    } finally {
      this.refresh();
    }

  }

}