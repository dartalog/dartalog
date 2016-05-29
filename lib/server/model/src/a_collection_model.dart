part of model;

abstract class AItemCollectionModel extends _AModel {
  static final Logger _log = new Logger('AItemCollectionModel');

  Future<List<api.Collection>> getAll();
  Future<List<api.IdNamePair>> getAllIdsAndNames();
  Future<api.Collection> getById(String id);

  Future write(api.Collection collection, [String id = null]);
}
