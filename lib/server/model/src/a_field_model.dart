part of model;

abstract class AFieldModel extends _AModel {
  static final Logger _log = new Logger('AFieldModel');

  AFieldModel();

  Future<Map<String, api.Field>> getAll();

  Future write(api.Field field, [String id = null]);

}