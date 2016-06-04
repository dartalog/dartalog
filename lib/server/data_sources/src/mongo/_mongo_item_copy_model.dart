part of data_sources;

class _MongoItemCopyModel extends _AMongoModel<ItemCopy> with AItemCopyModel {
  static final Logger _log = new Logger('_MongoItemCopyModel');

  static const String _COLLECTION_ID_FIELD = "collectionId";
  static const String _COPY_FIELD = "copy";
  static const String _ITEM_ID_FIELD = "itemId";
  static const String _STATUS_FIELD = "status";
  static const String _UNIQUE_ID_FIELD = "uniqueId";

  Future delete(String itemId, int copy) => _deleteFromDb(
      mongo.where.eq(_ITEM_ID_FIELD, itemId).eq(_COPY_FIELD, copy));

  Future<List<ItemCopy>> getAll(List<ItemCopyId> itemCopies) async {
    return await _getFromDb(_generateSelector(itemCopies));
  }

  Future<List<ItemCopy>> getAllForItemId(String itemId) =>
      _getFromDb(mongo.where.eq(_ITEM_ID_FIELD, itemId));

  Future<ItemCopy> getByItemIdAndCopy(String itemId, int copy) =>
      _getForOneFromDb(
          mongo.where.eq(_ITEM_ID_FIELD, itemId).eq(_COPY_FIELD, copy));

  Future<ItemCopy> getByUniqueId(String uniqueId) =>
      _getForOneFromDb(mongo.where.eq(_UNIQUE_ID_FIELD, uniqueId));

  Future<ItemCopy> getLargestNumberedCopy(String itemId) async {
    dynamic criteria = mongo.where
        .eq(_ITEM_ID_FIELD, itemId)
        .sortBy(_COPY_FIELD, descending: true)
        .limit(1);
    ItemCopy output = await _getForOneFromDb(criteria);
    return output;
  }

  Future updateStatus(List<ItemCopyId> itemCopies, String status) async {
    await _updateFields(itemCopies, {_STATUS_FIELD: status});
  }

  Future write(ItemCopy itemCopy, [String itemId, int copy]) async {
    if (!tools.isNullOrWhitespace(itemId) || copy != null) {
      if (tools.isNullOrWhitespace(itemId) || copy == null)
        throw new Exception("Both itemId and copy are required");
      await _updateToDb(
          mongo.where.eq(_ITEM_ID_FIELD, itemId).eq(_COPY_FIELD, copy),
          itemCopy);
    } else {
      await _insertIntoDb(itemCopy);
    }
  }

  ItemCopy _createObject(Map data) {
    ItemCopy output = new ItemCopy();
    output.collectionId = data[_COLLECTION_ID_FIELD];
    output.copy = data[_COPY_FIELD];
    output.itemId = data[_ITEM_ID_FIELD];
    output.status = data[_STATUS_FIELD];

    if (tools.isNullOrWhitespace(data[_UNIQUE_ID_FIELD]))
      output.uniqueId = "";
    else
      output.uniqueId = data[_UNIQUE_ID_FIELD];

    return output;
  }

  dynamic _generateSelector(List<ItemCopyId> itemCopies) {
    dynamic query = null;
    for (ItemCopyId id in itemCopies) {
      if (query == null)
        query =
            mongo.where.eq(_ITEM_ID_FIELD, id.itemId).eq(_COPY_FIELD, id.copy);
      else
        query = mongo.where
            .eq(_ITEM_ID_FIELD, id.itemId)
            .eq(_COPY_FIELD, id.copy)
            .or(query);
    }
    return query;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemCopiesCollection();

  Future _updateFields(
      List<ItemCopyId> itemCopies, Map<String, String> fields) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);
      mongo.ModifierBuilder operation;
      for (String key in fields.keys) {
        if (operation == null)
          operation = mongo.modify.set(key, fields[key]);
        else
          operation = operation.addToSet(key, fields[key]);
      }
      await collection.update(_generateSelector(itemCopies), operation);
    } finally {
      con.release();
    }
  }

  void _updateMap(ItemCopy itemCopy, Map data) {
    data[_COLLECTION_ID_FIELD] = itemCopy.collectionId;
    data[_COPY_FIELD] = itemCopy.copy;
    data[_ITEM_ID_FIELD] = itemCopy.itemId;
    if (!tools.isNullOrWhitespace(itemCopy.uniqueId))
      data[_UNIQUE_ID_FIELD] = itemCopy.uniqueId;
    if (!tools.isNullOrWhitespace(itemCopy.status))
      data[_STATUS_FIELD] = itemCopy.status;
  }
}
