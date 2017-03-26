import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class ACollectionDataSource
    extends AIdNameBasedDataSource<Collection> {
  static final Logger _log = new Logger('ACollectionDataSource');

  Future<UuidDataList<Collection>> getVisibleCollections(String userUuid);
  Future<UuidDataList<Collection>> getAllForCurator(String userUuid);
}
