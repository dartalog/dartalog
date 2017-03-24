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

  @override
  Future<List<User>> getAdmins() {
    return this.getFromDb(where.eq(TYPE_FIELD, UserPrivilege.admin));
  }

  @override
  Future<Option<String>> getPasswordHash(String id) async {
    final SelectorBuilder selector = where.eq(idField, id);
    final Option<String> data = await genericFindOne(selector);
    return data.map((Map user) {
      if (user.containsKey(PASSWORD_FIELD)) return user[PASSWORD_FIELD];
    });
  }

  @override
  Future<Null> setPassword(String id, String password) async {
    final SelectorBuilder selector = where.eq(idField, id);

    final ModifierBuilder modifier = modify.set(PASSWORD_FIELD, password);
    await genericUpdate(selector, modifier, multiUpdate: false);
  }

  @override
  User createObject(Map data) {
    final User output = new User();
    setIdDataFields(output, data);
    if (data.containsKey(TYPE_FIELD)) output.type = data[TYPE_FIELD];
    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getUsersCollection();

  @override
  void updateMap(User user, Map data) {
    super.updateMap(user, data);
    data["type"] = user.type;
  }
}
