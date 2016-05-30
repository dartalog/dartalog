part of data_sources;

abstract class AFieldModel extends AIdNameBasedDataSource<Field> {
  static final Logger _log = new Logger('AFieldModel');
  
  Future<List<Field>> getByIds(List<String> ids);
}
