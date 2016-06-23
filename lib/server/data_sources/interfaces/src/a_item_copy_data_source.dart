part of data_sources.interfaces;

abstract class AItemCopyDataSource extends _ADataSource {
  static final Logger _log = new Logger('AItemCopyModel');

  Future delete(String itemId, int copy);
  Future<Option<ItemCopy>> getByItemIdAndCopy(String itemId, int copy);
  Future<bool> existsByItemIdAndCopy(String itemId, int copy);
  Future<Option<ItemCopy>> getByUniqueId(String uniqueId);
  Future<bool> existsByUniqueId(String uniqueId);
  Future<List<ItemCopy>> getAllForItemId(String itemId);
  Future<List<ItemCopy>> getVisibleForItemId(String itemId, String userName);
  Future<ItemCopyId> write(ItemCopy itemCopy, bool update);
  Future<int> getNextCopyNumber(String itemId);
  Future<List<ItemCopy>> getAll(List<ItemCopyId> itemCopies);
  Future updateStatus(List<ItemCopyId> itemCopies, String status);
}
