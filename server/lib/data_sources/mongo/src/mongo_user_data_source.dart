import 'dart:async';

import 'package:dartalog_shared/global.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';

import 'a_mongo_id_data_source.dart';
import 'constants.dart';

class MongoUserDataSource extends AMongoIdDataSource<User>
    with AUserDataSource {
  static final Logger _log = new Logger('MongoUserDataSource');

  static const String typeField = "type";
  static const String emailField = "email";
  static const String passwordField = "password";

  MongoUserDataSource(MongoDbConnectionPool pool): super(pool);

  @override
  User createObject(Map data) {
    final User output = new User();
    AMongoIdDataSource.setIdDataFields(output, data);
    if (data.containsKey(typeField)) output.type = data[typeField];
    if (data.containsKey(emailField)) output.email = data[emailField];
    return output;
  }

  @override
  Future<List<User>> getAdmins() {
    return this.getFromDb(where.eq(typeField, UserPrivilege.admin));
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getUsersCollection();

  @override
  Future<Option<String>> getPasswordHashByUsername(String username) async {
    final SelectorBuilder selector = where.eq(readableIdField, username);
    final Option<String> data = await genericFindOne(selector);
    return data.map((Map user) {
      if (user.containsKey(passwordField)) return user[passwordField];
    });
  }

  @override
  Future<Option<String>> getPasswordHashByUuid(String uuid) async {
    final SelectorBuilder selector = where.eq(uuidField, uuid);
    final Option<String> data = await genericFindOne(selector);
    return data.map((Map user) {
      if (user.containsKey(passwordField)) return user[passwordField];
    });
  }

  @override
  Future<Null> setPassword(String uuid, String password) async {
    final SelectorBuilder selector = where.eq(uuidField, uuid);

    final ModifierBuilder modifier = modify.set(passwordField, password);
    await genericUpdate(selector, modifier, multiUpdate: false);
  }

  @override
  void updateMap(User user, Map data) {
    super.updateMap(user, data);
    data[typeField] = user.type;
    data[emailField] = user.email;
  }
}
