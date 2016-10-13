import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_object_data_source.dart';

class MongoItemCopyHistoryDataSource extends AMongoObjectDataSource<ItemCopyHistoryEntry>
    with AItemCopyHistoryModel {
  static final Logger _log = new Logger('MongoItemCopyHistoryDataSource');

  Future<List<ItemCopyHistoryEntry>> getForItemCopy(
          String itemId, int copy) =>
      getFromDb(where.eq("itemId", itemId).eq("copy", copy));

  Future write(ItemCopyHistoryEntry itemCopyHistory) =>
      insertIntoDb(itemCopyHistory);

  @override
  ItemCopyHistoryEntry createObject(Map data) {
    ItemCopyHistoryEntry output = new ItemCopyHistoryEntry();
    output.copy = data["copy"];
    output.itemId = data["itemId"];
    output.action = data["action"];
    output.actionerUserId = data["actionerUserId"];
    output.operatorUserId = data["operatorUserId"];
    output.timestamp = data["timestamp"];

    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemCopyHistoryCollection();

  @override
  void updateMap(ItemCopyHistoryEntry itemCopyHistory, Map data) {
    data["copy"] = itemCopyHistory.copy;
    data["itemId"] = itemCopyHistory.itemId;
    data["action"] = itemCopyHistory.action;
    data["actionerUserId"] = itemCopyHistory.actionerUserId;
    data["operatorUserId"] = itemCopyHistory.operatorUserId;
    data["timestamp"] = itemCopyHistory.timestamp;
  }
}
