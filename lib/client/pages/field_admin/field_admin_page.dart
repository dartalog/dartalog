// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('field_admin_page.html')
library dartalog.client.pages.field_admin_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/iron_flex_layout.dart';

import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/client.dart';

import '../../api/dartalog.dart' as API;

/// A Polymer `<field-admin-page>` element.
@PolymerRegister('field-admin-page')
class FieldAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("FieldAdminPage");

  @Property(notify: true)
  List fieldIds = new List();
  @reflectable API.Field getFieldName(String key) => fields[key].name;

  Map fields = new Map();

  /// Constructor used to create instance of MainApp.
  FieldAdminPage.created() : super.created("Field Admin");

  @Property(notify: true) String currentUuid;
  @Property(notify: true) String currentName;
  @Property(notify: true) String currentType;
  @Property(notify: true) String currentFormat;

  @Property(notify: true) Iterable get FIELD_TYPE_KEYS => dartalog.FIELD_TYPES.keys;
  @reflectable String getFieldType(String key) => dartalog.FIELD_TYPES[key];

  PaperDialog get editDialog =>  $['editDialog'];

  void activateInternal(Map args) {
    this.refresh();
  }

  @override
  void clearValidation() {
    $['input_name'].invalid = false;
    $['input_type'].invalid = false;
    $['input_format'].invalid = false;

  }

  @reflectable
  Future refresh() async {
    try {
      this.reset();
      clear("fieldIds");
      fields.clear();

      API.MapOfField data = await api.fields.getAll();

      fields.addAll(data);

      addAll("fieldIds",data.keys);
    } catch (e, st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }


  @reflectable
  void reset() {
    clearValidation();
    set('currentUuid', null);
    set('currentFormat', "");
    set('currentType', "");
    set('currentName', "");
  }

  showModal(event, [_]) {
    //String uuid = target.dataset['uuid'];
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
  fieldClicked(event, [_]) async {
    try {
      String id = event.target.dataset["id"];
      API.Field field = this.fields[id];

      set('currentUuid', id);
      set('currentFormat', field.format);
      set('currentType', field.type);
      set('currentName', field.name);

      editDialog.open();
    } catch (e, st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }

  @reflectable
  validateField(event, [_]) {
    _log.info("Validating");
  }

  @reflectable
  cancelClicked(event, [_]) {
    editDialog.cancel();
    this.reset();
  }

  @reflectable
  saveClicked(event, [_]) async {
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
      editDialog.close();
    } on API.DetailedApiRequestError catch  ( e, st) {
      try {
      API.DetailedApiRequestError ex = e as API.DetailedApiRequestError;
      setErrorMesage(ex.errors);
      } catch (e, st) {
        _log.severe(e, st);
        window.alert(e.toString());
      }
    } catch (e, st) {
      _log.severe(e, st);
      window.alert(e.toString());
    } finally {
    }
  }

}