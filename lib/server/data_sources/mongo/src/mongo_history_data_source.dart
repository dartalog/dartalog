import 'dart:async';

import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'a_mongo_object_data_source.dart';
import 'constants.dart';

class MongoHistoryDataSource extends AMongoObjectDataSource<AHistoryEntry>
    with AHistoryDataSource {
  static final Logger _log = new Logger('MongoHistoryDataSource');

  static const String typeField = "type";

  static const String actionField = "action";

  static const String actionerUserUuidField = "actionerUserUuid";
  static const String fromCollectionUuidField = "fromCollectionUuid";
  static const String toCollectionUuidField = "toCollectionUuid";

  static const String timestampField = "timestamp";
  static const String operatorUserUuidField = "operatorUserUuid";

  static const String itemUuidField = "itemUuid";

  @override
  AHistoryEntry createObject(Map data) {
    dynamic output;
    switch (data[typeField]) {
      case ActionHistoryEntry.type:
        output = new ActionHistoryEntry();
        output.action = data[actionField];
        output.actionerUserUuid = data[actionerUserUuidField];
        break;
      case TransferHistoryEntry.type:
        output = new TransferHistoryEntry();
        output.fromCollectionUuid = data[fromCollectionUuidField];
        output.toCollectionUuid = data[toCollectionUuidField];
        break;
    }

    output.itemUuid = data[itemUuidField];
    output.itemCopyUuid = data[itemCopyUuidField];

    output.operatorUserUuid = data[operatorUserUuidField];
    output.timestamp = data[timestampField];

    return output;
  }
  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemCopyHistoryCollection();
  @override
  Future<List<AHistoryEntry>> getForItemCopy(String itemCopyUuid) =>
      getFromDb(where.eq(itemCopyUuidField, itemCopyUuid));

  @override
  void updateMap(AHistoryEntry historyEntry, Map data) {
    data[typeField] = historyEntry.entryType;
    data[itemCopyUuidField] = historyEntry.itemCopyUuid;
    data[itemUuidField] = historyEntry.itemUuid;
    data[operatorUserUuidField] = historyEntry.operatorUserUuid;
    data[timestampField] = historyEntry.timestamp;

    if (historyEntry is ActionHistoryEntry) {
      data[actionField] = historyEntry.action;
      data[actionerUserUuidField] = historyEntry.actionerUserUuid;
    } else if (historyEntry is TransferHistoryEntry) {
      data[fromCollectionUuidField] = historyEntry.fromCollectionUuid;
      data[toCollectionUuidField] = historyEntry.toCollectionUuid;
    }
  }

  @override
  Future<Null> write(AHistoryEntry historyEntry) => insertIntoDb(historyEntry);
}
