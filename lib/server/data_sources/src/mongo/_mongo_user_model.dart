part of data_sources;

class _MongoUserModel extends _AMongoIdModel<api.User> with AUserModel {
  static final Logger _log = new Logger('_MongoUserModel');

  api.User _createObject(Map data) {
    api.User output = new api.User();
    output.id = data["id"];
    output.name = data["name"];
    output.password = data["password"];
    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getUsersCollection();

  void _updateMap(api.User field, Map data) {
    data["id"] = field.id;
    data["name"] = field.name;
    if(!tools.isNullOrWhitespace(field.password))
      data["password"] = field.password;
  }
}
