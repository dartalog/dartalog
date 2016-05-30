part of model;

class CollectionsModel extends AIdNameBasedModel<Collection> {
  static final Logger _log = new Logger('CollectionsModel');
  Logger get _logger => _log;
  data_sources.AIdNameBasedDataSource<Collection> get dataSource => data_sources.itemCollections;

}