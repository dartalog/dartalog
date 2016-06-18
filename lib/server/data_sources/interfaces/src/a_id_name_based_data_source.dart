part of data_sources.interfaces;

abstract class AIdNameBasedDataSource<T extends AIdData> {
  static final Logger _log = new Logger('AIdModel');

  Future<IdNameList<T>> getAll();
  Future<PaginatedIdNameData<T>> getPaginated({int offset: 0, int limit: PAGINATED_DATA_LIMIT});
  Future<IdNameList<IdNamePair>> getAllIdsAndNames();
  Future<PaginatedIdNameData<IdNamePair>> getPaginatedIdsAndNames({int offset: 0, int limit: PAGINATED_DATA_LIMIT});
  Future<Option<T>> getById(String id);
  Future<String> write(T t, [String id = null]);
  Future delete(String id);
  Future<bool> exists(String id);
  Future<IdNameList<T>> search(String query);
  Future<PaginatedIdNameData<T>> searchPaginated(String query, {int offset: 0, int limit: PAGINATED_DATA_LIMIT});


}
