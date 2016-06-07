part of data_sources.mongo;

class MongoUserDataSource extends _AMongoIdDataSource<User> with AUserDataSource {
  static final Logger _log = new Logger('MongoUserDataSource');

  User _createObject(Map data) {
    User output = new User();
    output.getId = data[ID_FIELD];
    output.getName = data["name"];
    output.password = data["password"];
    return output;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getUsersCollection();

  void _updateMap(User field, Map data) {
    data[ID_FIELD] = field.getId;
    data["name"] = field.getName;
    if(!tools.isNullOrWhitespace(field.password))
      data["password"] = field.password;
  }
}
