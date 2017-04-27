import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class ATagCategoryDataSource extends AIdNameBasedDataSource<TagCategory> {
  static final Logger _log = new Logger('ATagCategoryDataSource');

}
