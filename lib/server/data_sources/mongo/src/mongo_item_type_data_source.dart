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
    final ItemType template = new ItemType();
    template.id = data[idField];
    template.name= data["name"];
    template.fieldIds = data["fieldIds"];
    return template;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemTypesCollection();

  @override
  void updateMap(ItemType template, Map data) {
    data[idField] = template.getId;
    data["name"] = template.getName;
    data["fieldIds"] = template.fieldIds;
  }
}
