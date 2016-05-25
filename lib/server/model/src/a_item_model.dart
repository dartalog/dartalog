part of model;

abstract class AItemModel extends _AModel {
  static final Logger _log = new Logger('AItemModel');

  AItemModel();

  Future<List<api.Item>> getAll();
  Future<api.Item> get(String id);

  Future write(api.Item item, [String id = null]);
  Future delete(String id);
}