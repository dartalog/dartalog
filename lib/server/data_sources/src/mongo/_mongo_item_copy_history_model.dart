part of data_sources;

class _MongoItemCopyHistoryModel extends _AMongoModel<ItemCopyHistoryEntry>
    with AItemCopyHistoryModel {
  static final Logger _log = new Logger('_MongoItemCopyModel');

  Future<List<ItemCopyHistoryEntry>> getForItemCopy(
          String itemId, int copy) =>
      _getFromDb(mongo.where.eq("itemId", itemId).eq("copy", copy));

  Future write(ItemCopyHistoryEntry itemCopyHistory) =>
      _insertIntoDb(itemCopyHistory);

  ItemCopyHistoryEntry _createObject(Map data) {
    ItemCopyHistoryEntry output = new ItemCopyHistoryEntry();
    output.copy = data["copy"];
    output.itemId = data["itemId"];
    output.action = data["action"];
    output.actionerUserId = data["actionerUserId"];
    output.operatorUserId = data["operatorUserId"];
    output.timestamp = data["timestamp"];

    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemCopyHistoryCollection();

  void _updateMap(ItemCopyHistoryEntry itemCopyHistory, Map data) {
    data["copy"] = itemCopyHistory.copy;
    data["itemId"] = itemCopyHistory.itemId;
    data["action"] = itemCopyHistory.action;
    data["actionerUserId"] = itemCopyHistory.actionerUserId;
    data["operatorUserId"] = itemCopyHistory.operatorUserId;
    data["timestamp"] = itemCopyHistory.timestamp;
  }
}
