// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("field_admin_page.html")
library dartalog.client.pages.field_admin_page;

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

/// A Polymer `<field-admin-page>` element.
@CustomTag('field-admin-page')
class FieldAdminPage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("FieldAdminPage");

  Map fields = new ObservableMap();

  /// Constructor used to create instance of MainApp.
  FieldAdminPage.created() : super.created("Field Admin");

  @published String currentUuid;
  @published String currentName;
  @published String currentType;
  @published String currentFormat;

  Map<String, String> get FIELD_TYPES => dartalog.FIELD_TYPES;

  void activateInternal(Map args) {
    this.refresh();
  }

  Future refresh() async {
    try {
      this.clear();

      fields.clear();

      API.MapOfField data = await api.fields.getAll();

      fields.addAll(data);
    } catch (e, st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  void clear() {
    this.currentUuid = null;
    this.currentFormat = "";
    this.currentType = "";
    this.currentName = "";
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

      this.currentFormat = field.format;
      this.currentName = field.name;
      this.currentType = field.type;
      this.currentUuid = id;
    } catch (e, st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  validateField(event, detail, target) {
    _log.info("Validating");
  }

  clearClicked(event, detail, target) {
    this.clear();
  }

  saveClicked(event, detail, target) async {
    try {
      API.Field field = new API.Field();
      field.name = this.currentName;
      field.type = this.currentType;
      field.format = this.currentFormat;

      if (this.currentUuid == null) {
        await this.api.fields.create(field);
      } else {
        await this.api.fields.update(field, this.currentUuid);
      }

      refresh();
    } catch (e, st) {
      _log.severe(e, st);
      window.alert(e.toString());
    } finally {
    }
  }

}