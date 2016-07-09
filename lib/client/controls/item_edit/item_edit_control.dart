// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_edit_control.html')
library dartalog.client.controls.item_edit;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'package:mime/mime.dart' as mime;
import 'package:dartalog/client/api/dartalog.dart' as API_Library;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('item-edit-control')
class ItemEditControl extends AControl {
  static final Logger _log = new Logger("ItemEdit");
  Logger get loggerImpl => _log;

  String originalItemId = "";

  @property
  bool isNew = true;

  @Property(notify: true)
  Item currentItem = new Item();

  @Property(notify: true, observer: "itemTypeChanged")
  String currentItemTypeId = "";

  @Property(notify: true)
  String newCollectionId;

  @Property(notify: true)
  String newUniqueId;

  @Property(notify: true)
  List<IdNamePair> collections;
  @Property(notify: true)
  List<IdNamePair> itemTypes;

  @Property(notify: true)
  bool itemTypesAvailable = false;

  API_Library.ImportResult importResult = null;

  ItemEditControl.created() : super.created();

  void reset() {
    importResult = null;
    _setCurrentItem(new Item());
    set("newCollectionId", "");
    set("newUniqueId", "");
    set("currentItemTypeId","");
    set("isNew", true);
    originalItemId = "";
  }

  Future activateInternal(Map args, [bool forceRefresh = false]) async {
    await handleApiExceptions(() async {
      reset();
      await loadItemTypes();
      set("itemTypesAvailable", itemTypes.isNotEmpty);
      set("isNew", true);
      if (args.containsKey(ROUTE_ARG_ITEM_ID_NAME)) {
        await _loadItem(args[ROUTE_ARG_ITEM_ID_NAME]);
        set("isNew", false);
      } else if (args.containsKey(ROUTE_ARG_ITEM_TYPE_ID_NAME)) {
        set("currentItemTypeId", args[ROUTE_ARG_ITEM_TYPE_ID_NAME]);
      } else if (args.containsKey("imported_item")) {
        dynamic newItem = args["imported_item"];
        if (!(newItem is Item)) {
          throw new Exception("Imported item must be of type Item");
        }
        originalItemId = "";
        _setCurrentItem(newItem);
      } else if (args.containsKey(ROUTE_ARG_IMPORT_RESULT_NAME)) {
        dynamic result = args[ROUTE_ARG_IMPORT_RESULT_NAME];
        if (!(result is API_Library.ImportResult)) {
          throw new Exception("Imported item must be of type ImportResult");
        }
        originalItemId = "";
        importResult = result;
        set("currentItemTypeId", result.itemTypeId);
      }
      await loadCollections();
    });
  }

  Future loadCollections() async {
    API_Library.ListOfIdNamePair collections = await  this.api.collections.getAllIdsAndNames();
    set("collections", IdNamePair.copyList(collections));
  }

  Future loadItemTypes() async {
    API_Library.ListOfIdNamePair itemTypes = await this.api.itemTypes.getAllIdsAndNames();
    set("itemTypes", IdNamePair.copyList(itemTypes));
  }

  Future<String> save() async {
    return await handleApiExceptions(() async {
      List<API_Library.MediaMessage> files = new List<API_Library.MediaMessage>();

      if(this.currentItem==null||this.currentItem.fields==null)
        throw new Exception("Please select an item type");

      for (Field f in this.currentItem.fields) {
        if (f.type == "image") {
          if (f.mediaMessage != null) {
            files.add(f.mediaMessage);
            f.value = "${FILE_UPLOAD_PREFIX}${files.length-1}";
          }
        }
      }

      API_Library.Item newItem = new API_Library.Item();
      currentItem.copyTo(newItem);

      if (!isNullOrWhitespace(this.originalItemId)) {
        API_Library.UpdateItemRequest request = new API_Library.UpdateItemRequest();
        request.item = newItem;
        request.files = files;
        API_Library.IdResponse idResponse =
            await api.items.updateItem(request, this.originalItemId);
        return idResponse.id;
      } else {
        API_Library.CreateItemRequest request = new API_Library.CreateItemRequest();
        request.item = newItem;
        request.uniqueId = newUniqueId;
        request.collectionId = newCollectionId;
        request.files = files;

        API_Library.ItemCopyId itemCopyId = await api.items.createItemWithCopy(request);
        return itemCopyId.itemId;
      }
      return "";
    });
  }

  Future _loadItem(String id) async {
    API_Library.Item item =
        await api.items.getById(id, includeType: true, includeFields: true);
    Item newItem = new Item.copy(item);

    originalItemId = id;

    _setCurrentItem(newItem);
  }

  @reflectable
  Future itemTypeChanged([_, __]) async {
    if(api==null)
      return;

    API_Library.ItemType type = await api.itemTypes.getById(this.currentItemTypeId, includeFields: true);
    if (type == null)
      throw new Exception("Specified Item Type not found on server");

    Item newItem = new Item.forType(new ItemType.copy(type));
    originalItemId = "";

    if(importResult!=null)
      newItem.applyImportResult(importResult);

    _setCurrentItem(newItem);
  }

  void _setCurrentItem(Item newItem) {
    set("currentItem", newItem);
    set("currentItem.fields", newItem.fields);
    set("currentItem.name", newItem.name);
  }

  @reflectable
  imageInputChanged(event, [_]) {
    Element parent = getParentElement(event.target, "div");
    int index = int.parse(parent.dataset["index"]);
    Field field = this.currentItem.fields[index];
  }

  @reflectable
  uploadClicked(event, [_]) {
    Element parent = getParentElement(event.target, "div");
    InputElement input = parent.querySelector("input[type='file']");
    input.click();
  }

  @reflectable
  fileUploadChanged(event, [_]) async {
    Element parent = getParentElement(event.target, "div");
    int index = int.parse(parent.dataset["index"]);
    this.set("currentItem.fields.${index}.imageLoading", true);
    try {
      InputElement input = event.target;
      if (input.files.length == 0) return;
      File file = input.files[0];


      Field field = this.currentItem.fields[index];

      this.set("currentItem.fields.${index}.editImageUrl", file.name);
      FileReader reader = new FileReader();
      reader.readAsArrayBuffer(file);
      await for (dynamic fileEvent in reader.onLoad) {
        try {
          field.mediaMessage = new API_Library.MediaMessage();
          field.mediaMessage.bytes = reader.result;
          //List<String> parms = reader.result.toString().split(";");
          //field.mediaMessage.contentType = parms[0].split(":")[1];
          //field.mediaMessage.bytes = BASE64URL.decode(parms[1].split(",")[1]);

          field.mediaMessage.contentType = mime.lookupMimeType(
              file.name, headerBytes: field.mediaMessage.bytes.sublist(0, 10));


          String value = new Uri.dataFromBytes(field.mediaMessage.bytes,
              mimeType: field.mediaMessage.contentType).toString();
          this.set("currentItem.fields.${index}.displayImageUrl", value);
        }finally {
          this.set("currentItem.fields.${index}.imageLoading", false);
        }
      }
    } finally {
      this.set("currentItem.fields.${index}.imageLoading", false);
    }
  }
}
