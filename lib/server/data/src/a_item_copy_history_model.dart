part of data;

abstract class AItemCopyHistoryModel extends _ADataSource {
  static final Logger _log = new Logger('AItemCopyHistoryModel');

  Future<List<api.ItemCopyHistoryEntry>> getForItemCopy(String itemId, int copy);
  Future write(api.ItemCopyHistoryEntry itemCopy);

}
