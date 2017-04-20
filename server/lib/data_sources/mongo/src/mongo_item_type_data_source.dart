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

  MongoItemTypeDataSource(MongoDbConnectionPool pool): super(pool);

  @override
  ItemType createObject(Map data) {
    final ItemType output = new ItemType();
    setIdDataFields(output, data);
    output.fieldUuids = data[fieldUuidsField];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemTypesCollection();

  @override
  void updateMap(ItemType itemType, Map data) {
    super.updateMap(itemType, data);
    data[fieldUuidsField] = itemType.fieldUuids;
  }
}
