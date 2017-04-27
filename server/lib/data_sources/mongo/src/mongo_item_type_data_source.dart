import 'dart:async';

import 'package:dartalog/data/data.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'a_mongo_id_data_source.dart';

class MongoItemTypeDataSource extends AMongoIdDataSource<ItemType>
    with AItemTypeDataSource {
  static final Logger _log = new Logger('MongoItemTypeDataSource');

  static const String fieldUuidsField = "fieldUuids";
  static const String isFileTypeField = "isFileType";

  MongoItemTypeDataSource(MongoDbConnectionPool pool): super(pool);

  @override
  ItemType createObject(Map data) {
    final ItemType output = new ItemType();
    AMongoIdDataSource.setIdDataFields(output, data);
    output.fieldUuids = data[fieldUuidsField];
    output.isFileType = data[isFileTypeField];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemTypesCollection();

  @override
  void updateMap(ItemType itemType, Map data) {
    super.updateMap(itemType, data);
    data[fieldUuidsField] = itemType.fieldUuids;
    data[isFileTypeField] = itemType.isFileType;
  }
}
