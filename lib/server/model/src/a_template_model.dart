part of model;

abstract class ATemplateModel extends _AModel {
  static final Logger _log = new Logger('ATemplateModel');

  ATemplateModel();

  Future<Map<String, api.Template>> getAll();

  Future write(api.Template template, [String id = null]);

}