part of data;

class _MongoFieldModel extends _AMongoIdModel<api.Field> with AFieldModel {
  static final Logger _log = new Logger('_MongoFieldModel');

  Future<List<api.Field>> getByIds(List<String> ids) async {
    _log.info("Getting all fields for IDs");

    if (ids == null) return new List<api.Field>();

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

  api.Field _createObject(Map data) {
    api.Field output = new api.Field();
    output.id = data["id"];
    output.name = data["name"];
    output.type = data["type"];
    output.format = data["format"];
    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getFieldsCollection();

  void _updateMap(api.Field field, Map data) {
    data["id"] = field.id;
    data["name"] = field.name;
    data["type"] = field.type;
    data["format"] = field.format;
  }
}
