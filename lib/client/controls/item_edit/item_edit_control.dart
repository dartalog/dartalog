// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_edit_control.html')
library dartalog.client.controls.item_edit;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

@PolymerRegister('item-edit-control')
class ItemEditControl extends AControl  {
  static final Logger _log = new Logger("ItemEdit");

  String originalItemId = "";

  @Property(notify: true)
  Item currentItem = new Item();

  ItemEditControl.created() : super.created();

  Future activateInternal(Map args) async {
    if(args.containsKey(ROUTE_ARG_ITEM_ID_NAME)) {
      await _loadItem(args[ROUTE_ARG_ITEM_ID_NAME]);
    } else if(args.containsKey(ROUTE_ARG_ITEM_TYPE_ID_NAME)) {
      await _loadItemType(args[ROUTE_ARG_ITEM_TYPE_ID_NAME]);
    } else if(args.containsKey("imported_item")) {
      dynamic newItem = args["imported_item"];
      if(!(newItem is Item)) {
        throw new Exception("Imported item must be of type Item");
      }
      originalItemId = "";
      _setCurrentItem(newItem);
    }
  }

  Future _loadItem(String id) async {
    API.Item item = await api.items.getById(id, includeType: true, includeFields: true);
    Item newItem = new Item.copy(item);

    originalItemId = id;

    _setCurrentItem(newItem);
  }

  Future _loadItemType(String id) async {
    API.ItemType type = await api.itemTypes.getById(id, includeFields: true);
    Item newItem = new Item.forType(new ItemType.copy(type));
    originalItemId = "";
    _setCurrentItem(newItem);
  }

  void _setCurrentItem(Item newItem) {
    set("currentItem", newItem);
    set("currentItem.fields",newItem.fields);
    set("currentItem.name",newItem.name);
  }

  Future<String> save() async {
    try {
      API.Item newItem = new API.Item();
      currentItem.copyTo(newItem);

      API.IdResponse idResponse;
      if (!isNullOrWhitespace(this.originalItemId)) {
        idResponse =  await api.items.update(newItem, this.originalItemId);
      } else {
        idResponse  = await api.items.create(newItem);
      }
      return idResponse.id;
    } catch (e, st) {
      _log.severe(e, st);
      this.handleException(e,st);
    }
    return "";
  }
}