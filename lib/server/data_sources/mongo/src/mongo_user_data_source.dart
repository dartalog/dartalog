import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';
import 'a_mongo_id_data_source.dart';

class MongoUserDataSource extends AMongoIdDataSource<User>
    with AUserDataSource {
  static final Logger _log = new Logger('MongoUserDataSource');

  static const String TYPE_FIELD = "type";
  static const String PASSWORD_FIELD = "password";
  Future<List<User>> getAdmins() {
    return this.getFromDb(where.eq(TYPE_FIELD, UserPrivilege.admin));
  }

  Future<Option<String>> getPasswordHash(String id) async {
    SelectorBuilder selector = where.eq(ID_FIELD, id);
    Option data = await genericFindOne(selector);
    return data.map((Map user) {
      if (user.containsKey(PASSWORD_FIELD)) return user[PASSWORD_FIELD];
    });
  }

  Future setPassword(String id, String password) async {
    SelectorBuilder selector = where.eq(ID_FIELD, id);

    ModifierBuilder modifier = modify.set(PASSWORD_FIELD, password);
    await genericUpdate(selector, modifier, multiUpdate: false);
  }

  @override
  User createObject(Map data) {
    User output = new User();
    output.getId = data[ID_FIELD];
    output.getName = data["name"];
    if (data.containsKey(TYPE_FIELD)) output.type = data[TYPE_FIELD];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getUsersCollection();

  @override
  void updateMap(User user, Map data) {
    data[ID_FIELD] = user.getId;
    data["name"] = user.getName;
    data["type"] = user.type;
  }
}
