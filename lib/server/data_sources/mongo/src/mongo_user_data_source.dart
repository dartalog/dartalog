part of data_sources.mongo;

class MongoUserDataSource extends _AMongoIdDataSource<User>
    with AUserDataSource {
  static final Logger _log = new Logger('MongoUserDataSource');

  static const String TYPE_FIELD = "type";
  static const String PASSWORD_FIELD = "password";
  Future<List<User>> getAdmins() {
    return this._getFromDb(where.eq(TYPE_FIELD, UserPrivilege.admin));
  }

  Future<Option<String>> getPasswordHash(String id) async {
    SelectorBuilder selector = where.eq(ID_FIELD, id);
    Option data = await _genericFindOne(selector);
    return data.map((Map user) {
      if (user.containsKey(PASSWORD_FIELD)) return user[PASSWORD_FIELD];
    });
  }

  Future setPassword(String id, String password) async {
    SelectorBuilder selector = where.eq(ID_FIELD, id);

    ModifierBuilder modifier = modify.set(PASSWORD_FIELD, password);
    await _genericUpdate(selector, modifier, multiUpdate: false);
  }

  Future setType(String id, String type) async {
    SelectorBuilder selector = where.eq(ID_FIELD, id);

    ModifierBuilder modifier = modify.set(TYPE_FIELD, type);
    await _genericUpdate(selector, modifier, multiUpdate: false);
  }

  User _createObject(Map data) {
    User output = new User();
    output.getId = data[ID_FIELD];
    output.getName = data["name"];
    if (data.containsKey(TYPE_FIELD))
      output.type = data[TYPE_FIELD];
    return output;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getUsersCollection();

  void _updateMap(User user, Map data) {
    data[ID_FIELD] = user.getId;
    data["name"] = user.getName;
  }
}
