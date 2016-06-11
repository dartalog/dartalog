part of data_sources.interfaces;

abstract class ACollectionDataSource extends AIdNameBasedDataSource<Collection> {
  static final Logger _log = new Logger('ACollectionDataSource');

  Future<List<Collection>> getVisibleCollections(String userId);
  Future<List<Collection>> getAllForCurator(String userId);
}
