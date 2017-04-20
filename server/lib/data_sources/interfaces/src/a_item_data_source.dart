import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class AItemDataSource extends AIdNameBasedDataSource<Item> {
  static final Logger _log = new Logger('AItemDataSource');

  Future<UuidDataList<Item>> getVisible(String userUuid);
  Future<UuidDataList<Item>> searchVisible(String userUuid, String query);
  Future<UuidDataList<IdNamePair>> getVisibleIdsAndNames(String userUuid);
  Future<PaginatedUuidData<Item>> getVisiblePaginated(String userUuid,
      {int page: 0, int perPage: defaultPerPage});
  Future<PaginatedUuidData<Item>> searchVisiblePaginated(
      String userUuid, String query,
      {int page: 0, int perPage: defaultPerPage});
  Future<PaginatedUuidData<IdNamePair>> getVisibleIdsAndNamesPaginated(
      String userUuid,
      {int page: 0,
      int perPage: defaultPerPage});
}
