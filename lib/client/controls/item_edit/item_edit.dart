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
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

@PolymerRegister('item-edit')
class ItemEdit extends PolymerElement  {
  static final Logger _log = new Logger("ItemEdit");

  @Property(notify: true)
  Item currentItem = new Item();

  ItemEdit.created() : super.created();

  Future importData() async {

  }

  Future load(API.DartalogApi api, String id) async {
    API.Item item = await api.items.get(id, expand: "type,type.fields");
    set("currentItem", new Item.copy(item));
    set("currentItem.fields", currentItem.fields);
  }

  Future save(API.DartalogApi api) async {
    API.Item newItem = new API.Item();

    currentItem.copyTo(newItem);
    await api.items.create(newItem);
  }
}