import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:option/option.dart';

abstract class AIdNameBasedDataSource<T extends AIdData> extends Object {
  static final Logger _log = new Logger('AIdModel');

  Future<IdNameList<T>> getAll();
  Future<IdNameList<IdNamePair>> getAllIdsAndNames();
  Future<Option<T>> getById(String id);
  Future<String> write(T t, [String id = null]);
  Future<Null> deleteByID(String id);
  Future<bool> existsByID(String id);
  Future<IdNameList<T>> search(String query);
}
