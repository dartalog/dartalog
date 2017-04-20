import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class AFieldDataSource extends AIdNameBasedDataSource<Field> {
  static final Logger _log = new Logger('AFieldModel');

  Future<UuidDataList<Field>> getByUuids(List<String> uuids);
}
