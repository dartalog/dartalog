part of data_sources;

abstract class AIdNameBasedDataSource<T> {
  static final Logger _log = new Logger('AIdModel');

  Future<List<T>> getAll();
  Future<List<api.IdNamePairResponse>> getAllIdsAndNames();
  Future<T> getById(String id);
  Future<String> write(T t, [String id = null]);
  Future delete(String id);

}
