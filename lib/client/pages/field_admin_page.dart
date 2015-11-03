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

import '../api/dartalog.dart' as API;

/// A Polymer `<field-admin-page>` element.
@CustomTag('field-admin-page')
class FieldAdminPage extends APage {
  static final Logger _log = new Logger("FieldAdminPage");

  List fields = new ObservableList();

  /// Constructor used to create instance of MainApp.
  FieldAdminPage.created() : super.created();

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
    fields.clear();

    API.ListOfField data = await api.fields.getAll();

    fields.addAll(data);
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
  }

  @override
  addItem() {
  }

  validateField(event, detail, target) {
    _log.info("Validating");
  }

  saveClicked(event, detail, target) async {
    try {

      API.Field field = new API.Field();

      this.api.fields.create(field);

      loadProperties();

    } catch(e,st) {
      _log.severe(e,st);
    }

  }

}