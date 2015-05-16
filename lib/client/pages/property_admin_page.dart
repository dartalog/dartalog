// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_action_dialog.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';

/// A Polymer `<property-admin-page>` element.
@CustomTag('property-admin-page')
class PropertyAdminPage extends APage {
  static final Logger _log = new Logger("PropertyAdminPage");

  Map fields = new ObservableMap();

  /// Constructor used to create instance of MainApp.
  PropertyAdminPage.created() : super.created();

  @observable Map schema = new ObservableMap();
  @observable Map field_errors = new ObservableMap();

  @observable String current_field_uuid = '';
  @observable Map current_field = new ObservableMap();

  @override
  void init(Api api) {
    super.init(api);
    this.supportsAdding = true;
    this.title = "Property Admin";
    loadProperties();

  }

  Future loadProperties() async {
    schema.clear();
    fields.clear();

    Map data = await api.getAllProperties();
    fields.addAll(data["data"]);
    schema.addAll(data["schema"]);
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

// Optional lifecycle methods - uncomment if needed.

//  /// Called when an instance of main-app is inserted into the DOM.
//  attached() {
//    super.attached();
//  }

//  /// Called when an instance of main-app is removed from the DOM.
//  detached() {
//    super.detached();
//  }

//  /// Called when an attribute (such as a class) of an instance of
//  /// main-app is added, changed, or removed.
//  attributeChanged(String name, String oldValue, String newValue) {
//    super.attributeChanges(name, oldValue, newValue);
//  }

//  /// Called when main-app has been fully prepared (Shadow DOM created,
//  /// property observers set up, event listeners attached).
//  ready() {
//    super.ready();
//  }
}