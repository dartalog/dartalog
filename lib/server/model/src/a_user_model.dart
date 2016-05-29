part of model;

abstract class AUserModel extends _AModel {
  static final Logger _log = new Logger('a_field_model.dart');

  AFieldModel();

  Future<List<api.User>> getAll();
  Future<api.User> getById(String id);

  Future write(api.User user, [String id = null]);

}