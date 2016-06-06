part of data_sources;

class _MongoUserDataSource extends _AMongoIdDataSource<User> with AUserDataSource {
  static final Logger _log = new Logger('_MongoUserDataSource');

  User _createObject(Map data) {
    User output = new User();
    output.getId = data["id"];
    output.getName = data["name"];
    output.password = data["password"];
    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getUsersCollection();

  void _updateMap(User field, Map data) {
    data["id"] = field.getId;
    data["name"] = field.getName;
    if(!tools.isNullOrWhitespace(field.password))
      data["password"] = field.password;
  }
}
