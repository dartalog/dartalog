// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_add_control.html')
library dartalog.client.controls.item_edit;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/paper_tooltip.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

@PolymerRegister('item-add-control')
class ItemAddControl extends AControl  {
  static final Logger _log = new Logger("ItemEdit");

  @Property(notify: true)
  String selectedImportSource = "amazon";

  @Property(notify: true)
  List<IdNamePair> itemTypes= new List<IdNamePair>();

  PaperDialog get addItemMethodDialog =>  $['addItemMethodDialog'];
  PaperDialog get importSourceDialog =>  $['importSourceDialog'];
  PaperDialog get selectItemTypeDialog =>  $['selectItemTypeDialog'];


  ItemAddControl.created() : super.created();

  @reflectable
  paperDialogCancelClicked(event, [_]) => super.paperDialogCancelClicked(event, [_]);

  Future activateInternal(Map args) async {
    //await this.refresh();
  }

  Future start() {
    addItemMethodDialog.open();
  }

  Future loadItemTypes() async {
    try {
      clear("itemTypes");
      API.ListOfIdNamePair data = await api.itemTypes.getAllIdsAndNames();
      addAll("itemTypes", IdNamePair.convertList(data));
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

  @reflectable
  Future manualClicked(event, [_]) async {
    await loadItemTypes();
    addItemMethodDialog.close();
    selectItemTypeDialog.open();
  }

  @reflectable
  importClicked(event, [_]) {
    addItemMethodDialog.close();
    this.mainApp.activateRoute(ITEM_IMPORT_ROUTE_PATH);
  }

  @reflectable
  itemTypeClicked(event, [_]) {
    selectItemTypeDialog.close();
    PaperItem item = getParentElement(event.target,"paper-item");
    String id = item.dataset["id"];
    this.mainApp.activateRoute(ITEM_ADD_ROUTE_PATH, arguments: {ROUTE_ARG_ITEM_TYPE_ID_NAME: id});
  }

  @reflectable
  chooseImportSourceClicked(event, [_]) {

  }

  @reflectable
  addClicked(event, [_]) async {
    try {
      this.start();
    } catch(e,st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
  }

}