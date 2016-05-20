part of model;

abstract class ASettingsModel extends _AModel {
  static final Logger _log = new Logger('ASettingsModel');

  AFieldModel();

  Future<Map<String, String>> getAll();
  Future<api.Field> get(Settings setting);

  Future write(Settings setting, String value);

}