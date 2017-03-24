import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_id_data_source.dart';

class MongoItemTypeDataSource extends AMongoIdDataSource<ItemType>
    with AItemTypeModel {
  static final Logger _log = new Logger('MongoItemTypeDataSource');

  @override
  ItemType createObject(Map data) {
    final ItemType output = new ItemType();
    setIdDataFields(output,data);
    output.fieldIds = data["fieldIds"];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemTypesCollection();

  @override
  void updateMap(ItemType itemType, Map data) {
    updateMap(itemType, data);
    data["fieldIds"] = itemType.fieldIds;
  }
}
