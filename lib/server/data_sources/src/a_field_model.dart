part of data_sources;

abstract class AFieldModel extends AIdNameBasedDataSource<api.Field> {
  static final Logger _log = new Logger('AFieldModel');
  
  Future<List<api.Field>> getByIds(List<String> ids);
}
