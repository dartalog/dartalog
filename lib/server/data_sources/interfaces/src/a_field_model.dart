part of data_sources.interfaces;

abstract class AFieldModel extends AIdNameBasedDataSource<Field> {
  static final Logger _log = new Logger('AFieldModel');
  
  Future<IdNameList<Field>> getByIds(List<String> ids);
}
