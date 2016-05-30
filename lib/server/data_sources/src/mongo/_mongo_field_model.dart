part of data_sources;

class _MongoFieldModel extends _AMongoIdModel<Field> with AFieldModel {
  static final Logger _log = new Logger('_MongoFieldModel');

  Future<List<Field>> getByIds(List<String> ids) async {
    _log.info("Getting all fields for IDs");

    if (ids == null) return new List<Field>();

    mongo.SelectorBuilder query = null;

    for (String id in ids) {
      mongo.SelectorBuilder sb = mongo.where.eq("id", id);
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
    output.id = data["id"];
    output.name = data["name"];
    output.type = data["type"];
    output.format = data["format"];
    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getFieldsCollection();

  void _updateMap(Field field, Map data) {
    data["id"] = field.id;
    data["name"] = field.name;
    data["type"] = field.type;
    data["format"] = field.format;
  }
}
