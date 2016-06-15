part of data_sources.interfaces;

abstract class ACollectionDataSource extends AIdNameBasedDataSource<Collection> {
  static final Logger _log = new Logger('ACollectionDataSource');

  Future<IdNameList<Collection>> getVisibleCollections(String userId);
  Future<IdNameList<Collection>> getAllForCurator(String userId);
}
