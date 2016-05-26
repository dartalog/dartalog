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
class ItemEditPage extends APage {
  static final Logger _log = new Logger("ItemEditPage");

  /// Constructor used to create instance of MainApp.
  ItemEditPage.created() : super.created("Item Edit");

  String currentItemId;

  @override
  Future activateInternal(Map args) async {
    if(isNullOrWhitespace(args["itemId"])) {
      throw new Exception("itemId is required");
    }
    this.currentItemId = args["itemId"];
  }

}
