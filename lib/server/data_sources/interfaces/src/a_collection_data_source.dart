import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class ACollectionDataSource
    extends AIdNameBasedDataSource<Collection> {
  static final Logger _log = new Logger('ACollectionDataSource');

  Future<IdNameList<Collection>> getVisibleCollections(String userId);
  Future<IdNameList<Collection>> getAllForCurator(String userId);
}
