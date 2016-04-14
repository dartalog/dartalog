part of model;

abstract class AItemTypeModel extends _AModel {
  static final Logger _log = new Logger('AItemTypeModel');

  AItemTypeModel();

  Future<Map<String, api.ItemType>> getAll();
  Future<api.ItemType> get(String id);

  Future write(api.ItemType itemType, [String id = null, bool allowIdInsert = false]);

}