import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class ATagDataSource extends AIdNameBasedDataSource<Tag> {
  static final Logger _log = new Logger('ATagDataSource');

  Future<UuidDataList<Tag>> getByUuids(List<String> uuids);
}
