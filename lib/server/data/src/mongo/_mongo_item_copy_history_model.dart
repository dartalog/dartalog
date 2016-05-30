part of data;

class _MongoItemCopyHistoryModel extends _AMongoModel<api.ItemCopyHistoryEntry>
    with AItemCopyHistoryModel {
  static final Logger _log = new Logger('_MongoItemCopyModel');

  Future<List<api.ItemCopyHistoryEntry>> getForItemCopy(
          String itemId, int copy) =>
      _getFromDb(mongo.where.eq("itemId", itemId).eq("copy", copy));

  Future write(api.ItemCopyHistoryEntry itemCopyHistory) =>
      _insertIntoDb(itemCopyHistory);

  api.ItemCopyHistoryEntry _createObject(Map data) {
    api.ItemCopyHistoryEntry output = new api.ItemCopyHistoryEntry();
    output.copy = data["copy"];
    output.itemId = data["itemId"];
    output.action = data["action"];
    output.actionerUserId = data["actionerUserId"];
    output.operatorUserId = data["operatorUserId"];
    output.timestamp = data["timestamp"];

    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemTypesCollection();

  void _updateMap(api.ItemCopyHistoryEntry itemCopyHistory, Map data) {
    data["copy"] = itemCopyHistory.copy;
    data["itemId"] = itemCopyHistory.itemId;
    data["action"] = itemCopyHistory.action;
    data["actionerUserId"] = itemCopyHistory.actionerUserId;
    data["operatorUserId"] = itemCopyHistory.operatorUserId;
    data["timestamp"] = itemCopyHistory.timestamp;
  }
}
