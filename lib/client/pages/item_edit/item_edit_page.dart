// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("item_edit_page.html")
library dartalog.client.pages.item_edit_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/controls/item_edit/item_edit_control.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

@PolymerRegister('item-edit-page')
class ItemEditPage extends APage with ASaveablePage, ASubPage {
  static final Logger _log = new Logger("ItemEditPage");

  /// Constructor used to create instance of MainApp.
  ItemEditPage.created() : super.created("Item Edit");

  String currentItemId;

  ItemEditControl get itemEditControl => $['itemEditPageItemEditControl'];

  @override
  Future activateInternal(Map args) async {
    if(isNullOrWhitespace(args[ROUTE_ARG_ITEM_ID_NAME])) {
      throw new Exception("{$ROUTE_ARG_ITEM_ID_NAME} is required");
    }
    this.currentItemId = args[ROUTE_ARG_ITEM_ID_NAME];

    await itemEditControl.activate(this.api, args);
  }


  @override
  Future goBack() async {
    this.mainApp.activateRoute(ITEM_VIEW_ROUTE_PATH, arguments: {ROUTE_ARG_ITEM_ID_NAME: this.currentItemId});
  }

  @override
  Future save() async {
    String id = await itemEditControl.save();
    if(!isNullOrWhitespace(id)) {
      showMessage("Item saved");
      this.mainApp.activateRoute(ITEM_VIEW_ROUTE_PATH,
          arguments: {ROUTE_ARG_ITEM_ID_NAME: id});
    }
  }
}
