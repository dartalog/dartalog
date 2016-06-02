// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('collections_page.html')
library dartalog.client.pages.collections_page;

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
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

/// A Polymer `<field-admin-page>` element.
@PolymerRegister('collections-page')
class CollectionsPage extends APage with ARefreshablePage, ACollectionPage {
  static final Logger _log = new Logger("CollectionsPage");
  Logger get loggerImpl => _log;

  @property
  List<IdNamePair> collections = new List<IdNamePair>();

  String currentId = "";
  @property Collection currentCollection = new Collection();

  /// Constructor used to create instance of MainApp.
  CollectionsPage.created() : super.created("Collection Maintenance");

  PaperDialog get editDialog =>  $['editDialog'];

  Future activateInternal(Map args) async {
    await this.refresh();
  }

  @override
  void clearValidation() {
    $['output_error'].text = "";
    super.clearValidation();
  }

  @reflectable
  Future refresh() async {
    try {
      this.reset();
      clear("collections");

      API.ListOfIdNamePair data = await api.collections.getAllIdsAndNames();

      for(API.IdNamePair pair  in data) {
        add("collections", new IdNamePair.copy(pair));
      }
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }


  @reflectable
  void reset() {
    clearValidation();
    currentId = "";
    set('currentCollection', new Collection());
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
      this.handleException(e,st);
    }
  }

  @reflectable
  collectionClicked(event, [_]) async {
    try {
      String id = event.target.dataset["id"];
      if(id==null)
        return;

      API.Collection collection = await api.collections.getById(id);

      if(collection==null)
        throw new Exception("Selected collection not found");

      currentId = id;

      set("currentCollection", new Collection.copy(collection));

      editDialog.open();
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
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
      API.Collection collection = new API.Collection();
      currentCollection.copyTo(collection);
      if (isNullOrWhitespace(this.currentId)) {
        await this.api.collections.create(collection);
      } else {
        await this.api.collections.update(collection, this.currentId);
      }

      refresh();
      editDialog.close();
      showMessage("Collection saved");
    } on API.DetailedApiRequestError catch  ( e, st) {
      handleApiError(e, generalErrorField: "output_field_error");
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    } finally {
    }
  }

}