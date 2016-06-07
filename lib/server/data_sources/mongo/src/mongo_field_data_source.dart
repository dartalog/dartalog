part of data_sources.mongo;

class MongoFieldDataSource extends _AMongoIdDataSource<Field> with AFieldModel {
  static final Logger _log = new Logger('MongoFieldDataSource');

  Future<List<Field>> getByIds(List<String> ids) async {
    _log.info("Getting all fields for IDs");

    if (ids == null) return new List<Field>();

    SelectorBuilder query = null;

    for (String id in ids) {
      SelectorBuilder sb = where.eq(ID_FIELD, id);
      if (query == null) {
        query = sb;
      } else {
        query.or(sb);
      }
    }

    List results = await _getFromDb(query);

    return results;
  }

  Field _createObject(Map data) {
    Field output = new Field();
    output.getId = data[ID_FIELD];
    output.getName = data["name"];
    output.type = data["type"];
    output.format = data["format"];
    return output;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getFieldsCollection();

  void _updateMap(Field field, Map data) {
    data[ID_FIELD] = field.getId;
    data["name"] = field.getName;
    data["type"] = field.type;
    data["format"] = field.format;
  }
}
