// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_edit.html')
library dartalog.client.controls.item_edit;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_toast.dart';


@PolymerRegister('item-edit')
class ItemEdit extends PolymerElement  {
  static final Logger _log = new Logger("ItemEdit");

  ItemEdit.created() : super.created();

}