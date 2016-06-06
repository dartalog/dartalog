part of data_sources;

abstract class AItemDataSource extends AIdNameBasedDataSource<Item> {
  static final Logger _log = new Logger('AItemDataSource');

  Future<List<Item>> search(String query);
}