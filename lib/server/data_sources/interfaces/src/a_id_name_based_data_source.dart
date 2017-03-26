import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:option/option.dart';

import 'a_uuid_based_data_source.dart';

abstract class AIdNameBasedDataSource<T extends AHumanFriendlyData> extends AUuidBasedDataSource<T> {
  static final Logger _log = new Logger('AIdNameBasedDataSource');

  Future<UuidDataList<IdNamePair>> getAllIdsAndNames();
  Future<Option<T>> getByReadableId(String id);
  Future<bool> existsByReadableID(String id);
}
