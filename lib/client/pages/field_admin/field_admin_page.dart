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
import 'package:dartalog/client/data/data.dart';

import '../../api/dartalog.dart' as API;

/// A Polymer `<field-admin-page>` element.
@PolymerRegister('field-admin-page')
class FieldAdminPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("FieldAdminPage");

  @property
  List<Field> fields = new List<Field>();

  String currentId = "";
  @property Field currentField = new Field();

  /// Constructor used to create instance of MainApp.
  FieldAdminPage.created() : super.created("Field Admin");

  bool newField = true;

  @Property(notify: true) Iterable get FIELD_TYPE_KEYS => dartalog.FIELD_TYPES.keys;
  @reflectable String getFieldType(String key) => dartalog.FIELD_TYPES[key];

  PaperDialog get editDialog =>  $['editDialog'];

  void activateInternal(Map args) {
    this.refresh();
  }

  @override
  void clearValidation() {
    $['input_id'].invalid = false;
    $['input_name'].invalid = false;
    $['input_type'].invalid = false;
    $['input_format'].invalid = false;
    $['output_field_error'].text = "";
  }

  @reflectable
  Future refresh() async {
    try {
      this.reset();
      clear("fields");

      API.ListOfField data = await api.fields.getAll();

      for(API.Field f in data) {
        add("fields", new Field.copy(f));
      }
    } catch (e, st) {
      _log.severe(e, st);
      window.alert(e.toString());
    }
  }


  @reflectable
  void reset() {
    clearValidation();
    newField = true;
    currentId = "";
    set('currentField', new Field());
  }

  showModal(event, [_]) {
    //String uuid = target.dataset['uuid'];
  }

  @override
  Future newItem() async {
    try {
      this.reset();
      newField = true;
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
      if(id==null)
        return;

      Field field;
      for(Field f in fields) {
        if(f.id==id) {
          field = f;
          break;
        }
      }
      if(field==null)
        return;

      this.newField = false;

      currentId = id;

      set("currentField", new Field.copy(field));

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
      currentField.copyTo(field);
      if (this.newField) {
        await this.api.fields.create(field);
      } else {
        await this.api.fields.update(field, this.currentId);
      }

      refresh();
      editDialog.close();
    } on API.DetailedApiRequestError catch  ( e, st) {
      try {
        handleApiError(e, generalErrorField: "output_field_error");
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