// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_page.html")
library dartalog.client.pages.item_page;

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
@CustomTag('item-page')
class ItemPage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("ItemPage");

  Map fields = new ObservableMap();

  /// Constructor used to create instance of MainApp.
  ItemPage.created() : super.created("Item View");

  @observable Map items = new ObservableMap();

  @override
  void init(API.DartalogApi api) {
    super.init(api);
  }

  void activate(Map args) {
    this.refresh();
  }

  Future refresh() async {
    this.clear();
    await loadItems();
  }

  Future loadItems() async {
    try {
      items.clear();
      API.MapOfItem data = await api.items.getAll();
      items.addAll(data);
    } catch(e,st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  void clear() {
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