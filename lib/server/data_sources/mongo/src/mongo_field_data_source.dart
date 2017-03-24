import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_id_data_source.dart';

class MongoFieldDataSource extends AMongoIdDataSource<Field> with AFieldModel {
  static final Logger _log = new Logger('MongoFieldDataSource');

  @override
  Future<IdNameList<Field>> getByIds(List<String> ids) async {
    _log.info("Getting all fields for IDs");

    if (ids == null) return new List<Field>();

    SelectorBuilder query;

    for (String id in ids) {
      final SelectorBuilder sb = where.eq(idField, id);
      if (query == null) {
        query = sb;
      } else {
        query.or(sb);
      }
    }

    final List results = await getFromDb(query);

    final IdNameList<Field> output = new IdNameList<Field>.copy(results);

    output.sortBytList(ids);

    return output;
  }

  @override
  Field createObject(Map data) {
    Field output = new Field();
    setIdDataFields(output, data);
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
    updateMap(field, data);
    data["type"] = field.type;
    data["format"] = field.format;
    data["unique"] = field.unique;
  }
}
