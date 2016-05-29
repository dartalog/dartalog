part of model;

abstract class AItemCopyModel extends _AModel {
  static final Logger _log = new Logger('AItemCopyModel');

  Future delete(String itemId, int copy);
  Future<api.ItemCopy> getByItemIdAndCopy(String itemId, int copy);
  Future<api.ItemCopy> getByUniqueId(String uniqueId);
  Future<List<api.ItemCopy>> getAllForItemId(String itemId);
  Future write(api.ItemCopy itemCopy, {String itemId, int copy});

}
