part of data_sources.interfaces;

abstract class AIdNameBasedDataSource<T extends AIdData> {
  static final Logger _log = new Logger('AIdModel');

  Future<IdNameList<T>> getAll();
  Future<IdNameList<IdNamePair>> getAllIdsAndNames();
  Future<Option<T>> getById(String id);
  Future<String> write(T t, [String id = null]);
  Future delete(String id);
  Future<bool> exists(String id);
  Future<IdNameList<T>> search(String query);


}
