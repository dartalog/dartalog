part of data_sources.interfaces;

abstract class AItemDataSource extends AIdNameBasedDataSource<Item> {
  static final Logger _log = new Logger('AItemDataSource');

  Future<IdNameList<Item>> getVisible(String id);
  Future<IdNameList<Item>> searchVisible(String id, String query);
  Future<IdNameList<IdNamePair>> getVisibleIdsAndNames(String id);
}