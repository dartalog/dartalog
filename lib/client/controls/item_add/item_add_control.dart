// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_add_control.html')
library dartalog.client.controls.item_add;

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
import 'package:dartalog/client/pages/pages.dart';


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

  Future activateInternal([bool forceRefresh = false]) async {
    //await this.refresh();
    this.clearValidation();
  }

  Future start() {
    addItemMethodDialog.open();
  }

  Future loadItemTypes() async {
    await handleApiExceptions(() async {
      clear("itemTypes");
      API.ListOfIdNamePair data = await api.itemTypes.getAllIdsAndNames();
      addAll("itemTypes", IdNamePair.copyList(data));
    });
  }

  @reflectable
  Future manualClicked(event, [_]) async {
    await loadItemTypes();
    addItemMethodDialog.close();
    openDialog(selectItemTypeDialog);
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