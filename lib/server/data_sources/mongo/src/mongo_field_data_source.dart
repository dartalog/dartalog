part of data_sources.mongo;

class MongoFieldDataSource extends _AMongoIdDataSource<Field> with AFieldModel {
  static final Logger _log = new Logger('MongoFieldDataSource');

  Future<IdNameList<Field>> getByIds(List<String> ids) async {
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

    IdNameList<Field> output = new IdNameList<Field>.copy(results);

    output.sortBytList(ids);

    return output;
  }

  Field _createObject(Map data) {
    Field output = new Field();
    output.getId = data[ID_FIELD];
    output.getName = data["name"];
    output.type = data["type"];
    output.format = data["format"];

    if(data.containsKey("unique"))
      output.unique = data["unique"];
    return output;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getFieldsCollection();

  void _updateMap(Field field, Map data) {
    data[ID_FIELD] = field.getId;
    data["name"] = field.getName;
    data["type"] = field.type;
    data["format"] = field.format;
    data["unique"] = field.unique;
  }
}
