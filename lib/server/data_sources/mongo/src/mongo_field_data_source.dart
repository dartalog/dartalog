import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'a_mongo_id_data_source.dart';
import 'constants.dart';

class MongoFieldDataSource extends AMongoIdDataSource<Field> with AFieldModel {
  static final Logger _log = new Logger('MongoFieldDataSource');



  @override
  Future<UuidDataList<Field>> getByUuids(List<String> uuids) async {
    _log.info("Getting all fields for UUIDs");

    if (uuids == null) return new List<Field>();

    SelectorBuilder query;

    for (String uuid in uuids) {
      final SelectorBuilder sb = where.eq(uuidField, uuid);
      if (query == null) {
        query = sb;
      } else {
        query.or(sb);
      }
    }

    final List results = await getFromDb(query);

    final UuidDataList<Field> output = new UuidDataList<Field>.copy(results);

    output.sortBytList(uuids);

    return output;
  }

  static const String uniqueField = "unique";
  static const String typeField = "type";
  static const String formatField = "format";

  @override
  Field createObject(Map data) {
    final Field output = new Field();
    setIdDataFields(output, data);
    output.type = data[typeField];
    output.format = data[formatField];

    if (data.containsKey(uniqueField)) output.unique = data[uniqueField];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getFieldsCollection();

  @override
  void updateMap(Field field, Map data) {
    updateMap(field, data);
    data[typeField] = field.type;
    data[formatField] = field.format;
    data[uniqueField] = field.unique;
  }
}
