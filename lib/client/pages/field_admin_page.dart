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


import 'package:dartalog/dartalog.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';

import '../api/dartalog.dart';

/// A Polymer `<field-admin-page>` element.
@CustomTag('field-admin-page')
class FieldAdminPage extends APage {
  static final Logger _log = new Logger("FieldAdminPage");

  List fields = new ObservableList();

  /// Constructor used to create instance of MainApp.
  FieldAdminPage.created() : super.created();

  @observable Map schema = new ObservableMap();
  @observable Map field_errors = new ObservableMap();

  @observable String current_field_uuid = '';
  @observable Map current_field = new ObservableMap();

  @override
  void init(DartalogApi api) {
    super.init(api);
    this.supportsAdding = true;
    this.title = "Property Admin";
    loadProperties();
  }

  Future loadProperties() async {
    schema.clear();
    fields.clear();

    ListOfField data = await api.fields.getAll();

    fields.addAll(data);
    current_field.clear();
    current_field_uuid = '';
  }

  showModal(event, detail, target) {
    String uuid = target.dataset['uuid'];
    current_field.clear();
    current_field.addAll(this.fields[uuid]);
    current_field_uuid = uuid;
    field_errors.clear();
  }

  @override
  addItem() {
    this.current_field_uuid = "";
    this.current_field.clear();
  }

  validateField(event, detail, target) {
    _log.info("Validating");
  }

  saveClicked(event, detail, target) async {
    try {

      Map data = new Map();

      field_errors.clear();
      for(String field in schema['properties'].keys) {
        String value = current_field[field];

        if(isNullOrWhitespace(value)&&schema["required"].contains(field)) {
          field_errors[field] = "This field is required";
        }
        data[field] = value;
      }

      if(field_errors.length>0) {
        return;
      }

      await this.api.writeProperty(data,this.current_field_uuid);
      loadProperties();

    } catch(e,st) {
      _log.severe(e,st);
    }

  }

}