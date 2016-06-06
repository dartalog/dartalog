part of data_sources;

abstract class AItemCopyDataSource extends _ADataSource {
  static final Logger _log = new Logger('AItemCopyModel');

  Future delete(String itemId, int copy);
  Future<ItemCopy> getByItemIdAndCopy(String itemId, int copy);
  Future<ItemCopy> getByUniqueId(String uniqueId);
  Future<bool> existsByUniqueId(String uniqueId);
  Future<List<ItemCopy>> getAllForItemId(String itemId);
  Future<ItemCopyId> write(ItemCopy itemCopy, [String itemId, int copy]);
  Future<ItemCopy> getLargestNumberedCopy(String itemId);
  Future<List<ItemCopy>> getAll(List<ItemCopyId> itemCopies);
  Future updateStatus(List<ItemCopyId> itemCopies, String status);
}
