import 'package:logging/logging.dart';
import 'package:dartalog/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class AItemTypeDataSource extends AIdNameBasedDataSource<ItemType> {
  static final Logger _log = new Logger('AItemTypeModel');
}
