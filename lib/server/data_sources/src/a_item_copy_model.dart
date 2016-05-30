part of data_sources;

abstract class AItemCopyModel extends _ADataSource {
  static final Logger _log = new Logger('AItemCopyModel');

  Future delete(String itemId, int copy);
  Future<ItemCopy> getByItemIdAndCopy(String itemId, int copy);
  Future<ItemCopy> getByUniqueId(String uniqueId);
  Future<List<ItemCopy>> getAllForItemId(String itemId);
  Future write(ItemCopy itemCopy, [String itemId, int copy]);

}
