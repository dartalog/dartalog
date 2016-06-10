// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_edit_control.html')
library dartalog.client.controls.item_edit;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/api/dartalog.dart' as API;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('item-edit-control')
class ItemEditControl extends AControl {
  static final Logger _log = new Logger("ItemEdit");

  String originalItemId = "";

  @property
  bool isNew = true;

  @Property(notify: true)
  Item currentItem = new Item();

  @Property(notify: true)
  String newCollectionId;

  @Property(notify: true)
  String newUniqueId;

  ItemEditControl.created() : super.created();

  Future activateInternal(Map args) async {
    await handleApiExceptions(() async {
      set("isNew", true);
      if (args.containsKey(ROUTE_ARG_ITEM_ID_NAME)) {
        await _loadItem(args[ROUTE_ARG_ITEM_ID_NAME]);
        set("isNew", false);
      } else if (args.containsKey(ROUTE_ARG_ITEM_TYPE_ID_NAME)) {
        await _loadItemType(args[ROUTE_ARG_ITEM_TYPE_ID_NAME]);
      } else if (args.containsKey("imported_item")) {
        dynamic newItem = args["imported_item"];
        if (!(newItem is Item)) {
          throw new Exception("Imported item must be of type Item");
        }
        originalItemId = "";
        _setCurrentItem(newItem);
      }
    });
  }

  Future<String> save() async {
    await handleApiExceptions(() async {
      API.Item newItem = new API.Item();
      currentItem.copyTo(newItem);

      if (!isNullOrWhitespace(this.originalItemId)) {
        API.UpdateItemRequest request = new API.UpdateItemRequest();
        request.item = newItem;
        API.IdResponse idResponse =
            await api.items.updateItem(request, this.originalItemId);
        return idResponse.id;
      } else {
        API.CreateItemRequest request = new API.CreateItemRequest();
        request.item = newItem;
        request.uniqueId = newUniqueId;
        request.collectionId = newCollectionId;
        API.ItemCopyId itemCopyId = await api.items.createItemWithCopy(request);
        return itemCopyId.itemId;
      }
    });
    return "";
  }

  Future _loadItem(String id) async {
    API.Item item =
        await api.items.getById(id, includeType: true, includeFields: true);
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
    set("currentItem.fields", newItem.fields);
    set("currentItem.name", newItem.name);
  }
}
