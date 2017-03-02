import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_object_data_source.dart';

class MongoHistoryDataSource
    extends AMongoObjectDataSource<AHistoryEntry>
    with AHistoryDataSource {
  static final Logger _log = new Logger('MongoItemCopyHistoryDataSource');

  @override
  Future<List<AHistoryEntry>> getForItemCopy(String itemId, int copy) =>
      getFromDb(where.eq("itemId", itemId).eq("copy", copy));

  @override
  Future<Null> write(AHistoryEntry historyEntry) =>
      insertIntoDb(historyEntry);

  @override
  AHistoryEntry createObject(Map data) {
    dynamic  output;
    switch(data["type"]) {
      case ActionHistoryEntry.type:
        output = new ActionHistoryEntry();
        output.action = data["action"];
        output.actionerUserId = data["actionerUserId"];
        break;
      case TransferHistoryEntry.type:
        output = new TransferHistoryEntry();
        output.fromCollection = data["fromCollection"];
        output.toCollection = data["toCollection"];
        break;
    }

    output.copy = data["copy"];
    output.itemId = data["itemId"];
    output.operatorUserId = data["operatorUserId"];
    output.timestamp = data["timestamp"];

    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemCopyHistoryCollection();

  @override
  void updateMap(AHistoryEntry historyEntry, Map data) {
    data["type"] = historyEntry.entryType;
    data["copy"] = historyEntry.copy;
    data["itemId"] = historyEntry.itemId;
    data["operatorUserId"] = historyEntry.operatorUserId;
    data["timestamp"] = historyEntry.timestamp;

    if(historyEntry is ActionHistoryEntry) {
      data["action"] = historyEntry.action;
      data["actionerUserId"] = historyEntry.actionerUserId;
    } else if(historyEntry is TransferHistoryEntry) {
      data["fromCollection"] = historyEntry.fromCollection;
      data["toCollection"] = historyEntry.toCollection;
    }
  }
}
