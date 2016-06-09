part of data_sources.interfaces;

abstract class AIdNameBasedDataSource<T> {
  static final Logger _log = new Logger('AIdModel');

  Future<List<T>> getAll();
  Future<List<IdNamePair>> getAllIdsAndNames();
  Future<Option<T>> getById(String id);
  Future<String> write(T t, [String id = null]);
  Future delete(String id);
  Future<bool> exists(String id);
  Future<List<T>> search(String query);


}
