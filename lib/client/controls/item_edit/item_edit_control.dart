// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('item_edit_control.html')
library dartalog.client.controls.item_edit;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/api/api.dart' as api;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:mime/mime.dart' as mime;
import 'package:option/option.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('item-edit-control')
class ItemEditControl extends AControl {
  static final Logger _log = new Logger("ItemEdit");
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

  api.ImportResult _importResult;

  @Property(notify: true)
  Map routeData;

  ItemEditControl.created() : super.created();

  @override
  Logger get loggerImpl => _log;

  String get routeItemId {
    if (routeData != null && routeData.containsKey("item")) {
      return routeData["item"];
    }
    return StringTools.empty;
  }

  @override
  void attached() {
    super.attached();
    _loadPage();
  }

  @reflectable
  fileUploadChanged(event, [_]) async {
    final Option<Element> parent = getParentElement(event.target, "div");
    if (parent.isEmpty) throw new Exception("Parent div not found");

    final int index = int.parse(parent.get().dataset["index"]);
    this.set("currentItem.fields.$index.imageLoading", true);
    try {
      final InputElement input = event.target;
      if (input.files.length == 0) return;
      final File file = input.files[0];

      final Field field = this.currentItem.fields[index];

      this.set("currentItem.fields.$index.editImageUrl", file.name);
      final FileReader reader = new FileReader();
      reader.readAsArrayBuffer(file);
      await for (dynamic fileEvent in reader.onLoad) {
        try {
          field.mediaMessage = new api.MediaMessage();
          field.mediaMessage.bytes = reader.result;
          //List<String> parms = reader.result.toString().split(";");
          //field.mediaMessage.contentType = parms[0].split(":")[1];
          //field.mediaMessage.bytes = BASE64URL.decode(parms[1].split(",")[1]);

          field.mediaMessage.contentType = mime.lookupMimeType(file.name,
              headerBytes: field.mediaMessage.bytes.sublist(0, 10));

          final String value = new Uri.dataFromBytes(field.mediaMessage.bytes,
                  mimeType: field.mediaMessage.contentType)
              .toString();
          this.set("currentItem.fields.$index.displayImageUrl", value);
        } finally {
          this.set("currentItem.fields.$index.imageLoading", false);
        }
      }
    } finally {
      this.set("currentItem.fields.$index.imageLoading", false);
    }
  }

  @reflectable
  imageInputChanged(event, [_]) {
//    Element parent = getParentElement(event.target, "div");
//    int index = int.parse(parent.dataset["index"]);
//    Field field = this.currentItem.fields[index];
  }

  @reflectable
  Future itemTypeChanged([_, __]) async {
    await switchItemType();
  }

  Future loadCollections() async {
    final api.ListOfIdNamePair collections =
        await api.item.collections.getAllIdsAndNames();
    set("collections", IdNamePair.copyList(collections));
  }

  Future loadImportResult(api.ImportResult importResults) async {
    this._importResult = importResults;
    set("itemTypeId", importResults.itemTypeId);
    //await this.switchItemType();
  }

  Future loadItemTypes() async {
    final api.ListOfIdNamePair itemTypes =
        await api.item.itemTypes.getAllIdsAndNames();
    set("itemTypes", IdNamePair.copyList(itemTypes));
  }

  void reset() {
    _importResult = null;
    _setCurrentItem(new Item());
    set("newCollectionId", "");
    set("newUniqueId", "");
    set("currentItemTypeId", "");
    set("isNew", true);
    originalItemId = "";
  }

  Future<String> save() async {
    return await handleApiExceptions(() async {
      try {
        startLoading();

        final List<api.MediaMessage> files = new List<api.MediaMessage>();

        if (this.currentItem == null || this.currentItem.fields == null)
          throw new Exception("Please select an item type");

        for (Field f in this.currentItem.fields) {
          if (f.type == "image") {
            if (f.mediaMessage != null) {
              files.add(f.mediaMessage);
              f.value = "$fileUploadPrefix${files.length - 1}";
            }
          }
        }

        final api.Item newItem = new api.Item();
        currentItem.copyTo(newItem);

        if (!StringTools.isNullOrWhitespace(this.originalItemId)) {
          final api.UpdateItemRequest request = new api.UpdateItemRequest();
          request.item = newItem;
          request.files = files;
          final api.IdResponse idResponse =
              await api.item.items.updateItem(request, this.originalItemId);
          return idResponse.id;
        } else {
          final api.CreateItemRequest request = new api.CreateItemRequest();
          request.item = newItem;
          request.uniqueId = newUniqueId;
          request.collectionId = newCollectionId;
          request.files = files;

          final api.ItemCopyId itemCopyId =
              await api.item.items.createItemWithCopy(request);
          return itemCopyId.itemId;
        }
      } finally {
        stopLoading();
        this.evaluatePage();
      }
    });
  }

  Future switchItemType() async {
    if (StringTools.isNullOrWhitespace(this.itemTypeId)) return;

    final api.ItemType type =
        await api.item.itemTypes.getById(this.itemTypeId, includeFields: true);

    if (type == null)
      throw new Exception("Specified Item Type not found on server");

    final ItemType itemType = new ItemType.copy(type);

    final Item newItem = new Item.forType(itemType);

    originalItemId = "";

    if (_importResult != null) newItem.applyImportResult(_importResult);

    _setCurrentItem(newItem);
  }

  @reflectable
  uploadClicked(event, [_]) {
    final Option<Element> parent = getParentElement(event.target, "div");
    if (parent.isEmpty) throw new Exception("Parent div not found");

    final InputElement input = parent.get().querySelector("input[type='file']");
    input.click();
  }

  Future _loadItem(String id) async {
    final api.Item item = await api.item.items
        .getById(id, includeType: true, includeFields: true);
    final Item newItem = new Item.copy(item);

    originalItemId = id;

    _setCurrentItem(newItem);
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

        if (!StringTools.isNullOrWhitespace(routeItemId)) {
          await _loadItem(routeItemId);
          set("isNew", false);
        } else if (!StringTools.isNullOrWhitespace(itemTypeId)) {
          //set("itemTypeId", itemTypeId);
        } else {}
      } finally {
        stopLoading();
        this.evaluatePage();
      }
    });
  }

  void _setCurrentItem(Item newItem) {
    set("currentItem", newItem);
    set("currentItem.fields", newItem.fields);
    set("currentItem.name", newItem.name);
  }
}
