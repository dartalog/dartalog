part of data_sources.mongo;

class MongoItemCopyDataSource extends _AMongoObjectDataSource<ItemCopy>
    with AItemCopyDataSource {
  static final Logger _log = new Logger('MongoItemCopyDataSource');

  static const String _ITEM_COPIES_FIELD = "copies";

  static const String _COLLECTION_ID_FIELD = "collectionId";
  static const String _COPY_FIELD = "copy";
  static const String _STATUS_FIELD = "status";
  static const String _UNIQUE_ID_FIELD = "uniqueId";

  static const String _ITEM_COPIES_COPY_FIELD_PATH =
      "${_ITEM_COPIES_FIELD}.${_COPY_FIELD}";

  Future delete(String itemId, int copy) => _genericUpdate(
      where.eq(ID_FIELD, itemId),
      modify.pull(_ITEM_COPIES_FIELD, {_COPY_FIELD: copy}));

  Future<bool> existsByItemIdAndCopy(String itemId, int copy) async {
    List<ItemCopy> copies = await getAllForItemId(itemId, includeRemoved: true);
    for (ItemCopy itemCopy in copies) {
      if (itemCopy.copy == copy) return true;
    }
    return false;
  }

  Future<bool> existsByUniqueId(String uniqueId) =>
      _exists(where.eq("${_ITEM_COPIES_FIELD}.${_UNIQUE_ID_FIELD}", uniqueId));

  Future<List<ItemCopy>> getAll(List<ItemCopyId> itemCopies) async {
    List<ItemCopy> output = [];
    for (ItemCopyId id in itemCopies) {
      Option<Item> item = await data_sources.items.getById(id.itemId);
      item.map((Item i) =>
          i.getCopy(id.copy).map((ItemCopy itemCopy) => output.add(itemCopy)));
    }
    return output;
  }

  Future<List<ItemCopy>> getAllForItemId(String itemId,
      {bool includeRemoved: false}) async {
    //if (!includeRemoved) where.nin(_STATUS_FIELD, [ITEM_STATUS_REMOVED]);
    // TODO: Make sure removed items don't get returned when not requested
    List output =
        _convertList((await _getItemData(itemId))[_ITEM_COPIES_FIELD]);
    return output;
  }

  Future<List<ItemCopy>> getVisibleForItemId(String itemId, String userName,
      {bool includeRemoved: false}) async {
    //if (!includeRemoved) where.nin(_STATUS_FIELD, [ITEM_STATUS_REMOVED]);
    // TODO: Make sure removed items don't get returned when not requested
    List output =
    _convertList((await _getItemData(itemId))[_ITEM_COPIES_FIELD]);
    if (output.length == 0) return [];
    IdNameList<Collection> visibleCollections =
    await data_sources.itemCollections.getVisibleCollections(userName);
    output.retainWhere((ItemCopy ic) {
      return visibleCollections.containsId(ic.collectionId);
    });
    return output;
  }


  Future<Option<ItemCopy>> getByItemIdAndCopy(String itemId, int copy) async {
    List<ItemCopy> copies = await getAllForItemId(itemId, includeRemoved: true);
    for (ItemCopy itemCopy in copies) {
      itemCopy.itemId = itemId;
      if (itemCopy.copy == copy) return new Some(itemCopy);
    }
    return new None();
  }

  Future<Option<ItemCopy>> getByUniqueId(String uniqueId) async {
    List results = await _genericFind(where
        .eq("${_ITEM_COPIES_FIELD}.${_UNIQUE_ID_FIELD}", uniqueId)
        .limit(1));
    if (results.length > 0) {
      Map data = results[0];
      for (Map copy in data[_ITEM_COPIES_FIELD]) {
        if (copy[_UNIQUE_ID_FIELD] == uniqueId) {
          ItemCopy output = _createObject(copy);
          output.itemId = data[ID_FIELD];
          return new Some(output);
        }
      }
    }
    return new None();
  }

  Future<int> getNextCopyNumber(String itemId) async {
    // TODO: Convert this to use mongo aggregation
    Map data = await _getItemData(itemId);
    int candidate = 0;
    if (data.containsKey(_ITEM_COPIES_FIELD)) {
      for (Map copy in data[_ITEM_COPIES_FIELD]) {
        if (copy[_COPY_FIELD] > candidate) candidate = copy[_COPY_FIELD];
      }
    }
    candidate++;
    return candidate;
  }

  Future updateStatus(List<ItemCopyId> itemCopies, String status) async {
    SelectorBuilder selector = null;
    for (ItemCopyId id in itemCopies) {
      if (selector == null) {
        selector = where
            .eq(ID_FIELD, id.itemId)
            .eq(_ITEM_COPIES_COPY_FIELD_PATH, id.copy);
      } else {
        selector = selector.or(where
            .eq(ID_FIELD, id.itemId)
            .eq(_ITEM_COPIES_COPY_FIELD_PATH, id.copy));
      }
    }
    ModifierBuilder modifier =
        modify.set("${_ITEM_COPIES_FIELD}.\$.${_STATUS_FIELD}", status);
    await _genericUpdate(selector, modifier, multiUpdate: true);
  }

  Future<ItemCopyId> write(ItemCopy itemCopy, bool update) async {
    Map data = new Map();
    _updateMap(itemCopy, data);
    dynamic selector;
    dynamic modifier;
    if (update) {
      selector = where
          .eq(ID_FIELD, itemCopy.itemId)
          .eq(_ITEM_COPIES_COPY_FIELD_PATH, itemCopy.copy);

      modifier = modify;
      for (String key in data.keys) {
        modifier = modifier.set("${_ITEM_COPIES_FIELD}.\$.${key}", data[key]);
      }
    } else {
      selector = where.eq(ID_FIELD, itemCopy.itemId);
      modifier = modify.push(_ITEM_COPIES_FIELD, data);
    }

    await _genericUpdate(selector, modifier);

    return new ItemCopyId.fromItemCopy(itemCopy);
  }

  ItemCopy _createObject(Map data) => _staticCreateObject(data);

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemsCollection();
  Future<Map> _getItemData(String itemId) async {
    dynamic criteria = where.eq(ID_FIELD, itemId);
    List results = await _genericFind(criteria);
    if (results.length == 0)
      throw new NotFoundException("Requested item not found");
    return results[0];
  }

  void _updateMap(ItemCopy itemCopy, Map data) {
    data[_COLLECTION_ID_FIELD] = itemCopy.collectionId;
    data[_COPY_FIELD] = itemCopy.copy;
    if (!tools.isNullOrWhitespace(itemCopy.uniqueId))
      data[_UNIQUE_ID_FIELD] = itemCopy.uniqueId;
    if (!tools.isNullOrWhitespace(itemCopy.status))
      data[_STATUS_FIELD] = itemCopy.status;
  }

  static List<ItemCopy> _convertList(List data) {
    List<ItemCopy> output = new List<ItemCopy>();
    if (data == null) return output;
    for (dynamic item in data) {
      output.add(_staticCreateObject(item));
    }
    return output;
  }

  static ItemCopy _staticCreateObject(Map data) {
    ItemCopy output = new ItemCopy();
    output.collectionId = data[_COLLECTION_ID_FIELD];
    output.copy = data[_COPY_FIELD];
    output.status = data[_STATUS_FIELD];

    if (tools.isNullOrWhitespace(data[_UNIQUE_ID_FIELD]))
      output.uniqueId = "";
    else
      output.uniqueId = data[_UNIQUE_ID_FIELD];

    return output;
  }
}
