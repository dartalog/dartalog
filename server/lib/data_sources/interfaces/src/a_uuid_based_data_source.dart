import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/data/data.dart';
import 'package:option/option.dart';
import 'a_data_source.dart';

abstract class AUuidBasedDataSource<T extends AUuidData> extends ADataSource {
  static final Logger _log = new Logger('AUuidBasedDataSource');

  Future<UuidDataList<T>> getAll();
  Future<Option<T>> getByUuid(String uuid);
  Future<String> create(String uuid, T t);
  Future<String> update(String uuid, T t);
  Future<Null> deleteByUuid(String uuid);
  Future<bool> existsByUuid(String uuid);
  Future<UuidDataList<T>> search(String query);
}
