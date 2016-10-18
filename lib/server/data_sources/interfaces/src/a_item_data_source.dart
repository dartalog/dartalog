import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'a_id_name_based_data_source.dart';

abstract class AItemDataSource extends AIdNameBasedDataSource<Item> {
  static final Logger _log = new Logger('AItemDataSource');

  Future<IdNameList<Item>> getVisible(String id);
  Future<IdNameList<Item>> searchVisible(String id, String query);
  Future<IdNameList<IdNamePair>> getVisibleIdsAndNames(String id);
  Future<PaginatedIdNameData<Item>> getVisiblePaginated(String id,
      {int page: 0, int perPage: DEFAULT_PER_PAGE});
  Future<PaginatedIdNameData<Item>> searchVisiblePaginated(
      String id, String query,
      {int page: 0, int perPage: DEFAULT_PER_PAGE});
  Future<PaginatedIdNameData<IdNamePair>> getVisibleIdsAndNamesPaginated(
      String id,
      {int page: 0,
      int perPage: DEFAULT_PER_PAGE});
}
