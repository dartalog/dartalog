// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

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
  bool newItem = true;

  @Property(notify: true)
  Item currentItem = new Item();

  @Property(notify: true, observer: "itemTypeChanged")
  String itemTypeId = "";

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

  API_Library.ImportResult _importResult = null;

  @Property(notify: true)
  Map routeData;

  String get routeItemId {
    if (routeData != null && routeData.containsKey("item")) {
      return routeData["item"];
    }
    return EMPTY_STRING;
  }

  ItemEditControl.created() : super.created();

  void reset() {
    _importResult = null;
    _setCurrentItem(new Item());
    set("newCollectionId", "");
    set("newUniqueId", "");
    set("currentItemTypeId", "");
    set("isNew", true);
    originalItemId = "";
  }

  attached() {
    super.attached();
    _loadPage();
  }

  Future _loadPage() async {
    await handleApiExceptions(() async {
      try {
        startLoading();

        reset();
        await loadItemTypes();
        await loadCollections();

        set("itemTypesAvailable", itemTypes.isNotEmpty);
        set("isNew", true);

        if (!isNullOrWhitespace(routeItemId)) {
          await _loadItem(routeItemId);
          set("isNew", false);
        } else if (!isNullOrWhitespace(itemTypeId)) {
          //set("itemTypeId", itemTypeId);
        } else {}
      } finally {
        stopLoading();
        this.evaluatePage();
      }
    });
  }

  Future loadImportResult(API_Library.ImportResult importResults) async {
    this._importResult = importResults;
    set("itemTypeId", importResults.itemTypeId);
    //await this.switchItemType();
  }

  Future loadCollections() async {
    API_Library.ListOfIdNamePair collections =
        await this.api.collections.getAllIdsAndNames();
    set("collections", IdNamePair.copyList(collections));
  }

  Future loadItemTypes() async {
    API_Library.ListOfIdNamePair itemTypes =
        await this.api.itemTypes.getAllIdsAndNames();
    set("itemTypes", IdNamePair.copyList(itemTypes));
  }

  Future<String> save() async {
    return await handleApiExceptions(() async {
      try {
        startLoading();

        List<API_Library.MediaMessage> files =
        new List<API_Library.MediaMessage>();

        if (this.currentItem == null || this.currentItem.fields == null)
          throw new Exception("Please select an item type");

        for (Field f in this.currentItem.fields) {
          if (f.type == "image") {
            if (f.mediaMessage != null) {
              files.add(f.mediaMessage);
              f.value = "${FILE_UPLOAD_PREFIX}${files.length - 1}";
            }
          }
        }

        API_Library.Item newItem = new API_Library.Item();
        currentItem.copyTo(newItem);

        if (!isNullOrWhitespace(this.originalItemId)) {
          API_Library.UpdateItemRequest request =
          new API_Library.UpdateItemRequest();
          request.item = newItem;
          request.files = files;
          API_Library.IdResponse idResponse =
          await api.items.updateItem(request, this.originalItemId);
          return idResponse.id;
        } else {
          API_Library.CreateItemRequest request =
          new API_Library.CreateItemRequest();
          request.item = newItem;
          request.uniqueId = newUniqueId;
          request.collectionId = newCollectionId;
          request.files = files;

          API_Library.ItemCopyId itemCopyId =
          await api.items.createItemWithCopy(request);
          return itemCopyId.itemId;
        }
      } finally {
        stopLoading();
        this.evaluatePage();
      }
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
    await switchItemType();
  }

  Future switchItemType() async {
    if (api == null) return;

    API_Library.ItemType type = await api.itemTypes
        .getById(this.itemTypeId, includeFields: true);

    if (type == null)
      throw new Exception("Specified Item Type not found on server");

    ItemType itemType  = new ItemType.copy(type);

    Item newItem = new Item.forType(itemType);

    originalItemId = "";

    if (_importResult != null) newItem.applyImportResult(_importResult);

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

          field.mediaMessage.contentType = mime.lookupMimeType(file.name,
              headerBytes: field.mediaMessage.bytes.sublist(0, 10));

          String value = new Uri.dataFromBytes(field.mediaMessage.bytes,
                  mimeType: field.mediaMessage.contentType)
              .toString();
          this.set("currentItem.fields.${index}.displayImageUrl", value);
        } finally {
          this.set("currentItem.fields.${index}.imageLoading", false);
        }
      }
    } finally {
      this.set("currentItem.fields.${index}.imageLoading", false);
    }
  }
}
