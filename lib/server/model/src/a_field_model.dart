part of model;

abstract class AFieldModel extends _AModel {
  static final Logger _log = new Logger('AFieldModel');

  AFieldModel();

  Future<List<api.Field>> getAll();
  Future<List<api.Field>> getAllForIDs(List<String> ids);
  Future<api.Field> get(String id);

  Future write(api.Field field, [String id = null]);

}