part of model;

abstract class AItemModel extends _AModel {
  static final Logger _log = new Logger('AItemModel');

  AItemModel();

  Future<Map<String,api.Item>> getAll();

  Future write(api.Field field, [String id = null]);
}