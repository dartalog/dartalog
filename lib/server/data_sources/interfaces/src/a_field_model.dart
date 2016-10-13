import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class AFieldModel extends AIdNameBasedDataSource<Field> {
  static final Logger _log = new Logger('AFieldModel');
  
  Future<IdNameList<Field>> getByIds(List<String> ids);
}
