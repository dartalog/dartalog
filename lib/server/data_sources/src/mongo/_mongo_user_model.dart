part of data_sources;

class _MongoUserModel extends _AMongoIdModel<User> with AUserModel {
  static final Logger _log = new Logger('_MongoUserModel');

  User _createObject(Map data) {
    User output = new User();
    output.id = data["id"];
    output.name = data["name"];
    output.password = data["password"];
    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getUsersCollection();

  void _updateMap(User field, Map data) {
    data["id"] = field.id;
    data["name"] = field.name;
    if(!tools.isNullOrWhitespace(field.password))
      data["password"] = field.password;
  }
}
