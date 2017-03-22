import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_id_data_source.dart';

class MongoFieldDataSource extends AMongoIdDataSource<Field> with AFieldModel {
  static final Logger _log = new Logger('MongoFieldDataSource');

  Future<IdNameList<Field>> getByIds(List<String> ids) async {
    _log.info("Getting all fields for IDs");

    if (ids == null) return new List<Field>();

    SelectorBuilder query = null;

    for (String id in ids) {
      SelectorBuilder sb = where.eq(idField, id);
      if (query == null) {
        query = sb;
      } else {
        query.or(sb);
      }
    }

    List results = await getFromDb(query);

    IdNameList<Field> output = new IdNameList<Field>.copy(results);

    output.sortBytList(ids);

    return output;
  }

  @override
  Field createObject(Map data) {
    Field output = new Field();
    output.id = data[idField];
    output.name= data["name"];
    output.type = data["type"];
    output.format = data["format"];

    if (data.containsKey("unique")) output.unique = data["unique"];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getFieldsCollection();

  @override
  void updateMap(Field field, Map data) {
    data[idField] = field.getId;
    data["name"] = field.getName;
    data["type"] = field.type;
    data["format"] = field.format;
    data["unique"] = field.unique;
  }
}
