part of data_sources.interfaces;

abstract class AItemCopyHistoryModel extends _ADataSource {
  static final Logger _log = new Logger('AItemCopyHistoryModel');

  Future<List<ItemCopyHistoryEntry>> getForItemCopy(String itemId, int copy);
  Future write(ItemCopyHistoryEntry itemCopy);

}
