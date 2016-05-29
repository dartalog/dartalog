part of model;

abstract class AItemTypeModel extends _AModel {
  static final Logger _log = new Logger('AItemTypeModel');

  Future<List<api.ItemType>> getAll();
  Future<List<api.IdNamePair>> getAllIdsAndNames();
  Future<api.ItemType> getById(String id);

  Future write(api.ItemType itemType, [String id = null]);
}
