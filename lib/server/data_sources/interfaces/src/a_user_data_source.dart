import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:option/option.dart';
import 'a_id_name_based_data_source.dart';

abstract class AUserDataSource extends AIdNameBasedDataSource<User> {
  static final Logger _log = new Logger('AUserDataSource');

  Future<List<User>> getAdmins();

  Future<Null> setPassword(String id, String password);
  Future<Option<String>> getPasswordHash(String id);

  Future<Option<User>> getByUsername(String username) =>
      getByReadableId(username);
}
