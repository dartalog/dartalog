part of data_sources.mongo;

class MongoUserDataSource extends _AMongoIdDataSource<User> with AUserDataSource {
  static final Logger _log = new Logger('MongoUserDataSource');

  static const String PRIVILEGES_FIELD = "privileges";
  static const String PASSWORD_FIELD = "password";
  User _createObject(Map data) {
    User output = new User();
    output.getId = data[ID_FIELD];
    output.getName = data["name"];
    output.privileges = data[PRIVILEGES_FIELD];
    return output;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getUsersCollection();

  void _updateMap(User user, Map data) {
    data[ID_FIELD] = user.getId;
    data["name"] = user.getName;
  }

  Future<List<User>> getAdmins() {
    return this._getFromDb(where.eq(PRIVILEGES_FIELD, USER_PRIVILEGE_ADMIN));
  }

  Future setPrivileges(String id, List<String> privileges) async {
    SelectorBuilder selector = where.eq(ID_FIELD, id);

    ModifierBuilder modifier =
    modify.set(PRIVILEGES_FIELD, privileges);
    await _genericUpdate(selector, modifier, multiUpdate: false);
  }

  Future setPassword(String id, String password) async {
    SelectorBuilder selector = where.eq(ID_FIELD, id);

    ModifierBuilder modifier =
    modify.set(PASSWORD_FIELD, password);
    await _genericUpdate(selector, modifier, multiUpdate: false);
  }

  Future<Option<String>> getPasswordHash(String id) async {
    SelectorBuilder selector = where.eq(ID_FIELD, id);
    Map data = await _genericFind(selector);
    if(data.containsKey(PASSWORD_FIELD))
      return new Some(data[PASSWORD_FIELD]);
    return  new None();
  }
}
