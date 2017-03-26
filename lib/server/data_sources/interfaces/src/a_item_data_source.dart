import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class AItemDataSource extends AIdNameBasedDataSource<Item> {
  static final Logger _log = new Logger('AItemDataSource');

  Future<UuidDataList<Item>> getVisible(String userUuid);
  Future<UuidDataList<Item>> searchVisible(String userUuid, String query);
  Future<UuidDataList<IdNamePair>> getVisibleIdsAndNames(String userUuid);
  Future<PaginatedUuidData<Item>> getVisiblePaginated(String userUuid,
      {int page: 0, int perPage: DEFAULT_PER_PAGE});
  Future<PaginatedUuidData<Item>> searchVisiblePaginated(
      String userUuid, String query,
      {int page: 0, int perPage: DEFAULT_PER_PAGE});
  Future<PaginatedUuidData<IdNamePair>> getVisibleIdsAndNamesPaginated(
      String userUuid,
      {int page: 0,
      int perPage: DEFAULT_PER_PAGE});
}
