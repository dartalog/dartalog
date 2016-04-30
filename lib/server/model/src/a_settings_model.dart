part of model;

abstract class ASettingsModel extends _AModel {
  static final Logger _log = new Logger('AImportSettingsModel');

  AFieldModel();

  Future<Map<String, api.Field>> getAll();
  Future<api.Field> get(String id);

  Future write(api.Field field, [String id = null, bool allowIdInsert = false]);

}