part of model;

abstract class AFieldModel extends _AModel {
  static final Logger _log = new Logger('AFieldModel');

  Future<List<api.Field>> getAll();
  Future<List<api.IdNamePair>> getAllIdsAndNames();
  Future<api.Field> getById(String id);
  Future<List<api.Field>> getByIds(List<String> ids);

  Future write(api.Field field, [String id = null]);
}
