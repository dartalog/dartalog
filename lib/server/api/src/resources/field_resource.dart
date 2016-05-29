part of api;

class FieldResource extends AResource {
  static final Logger _log = new Logger('FieldResource');
  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${API_FIELDS_PATH}/')
  Future<IdResponse> create(Field field) async {
    try {
      await field.validate(true);
      String output = await model.fields.write(field);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_FIELDS_PATH}/')
  Future<List<IdNamePair>> getAllIdsAndNames() async {
    try {
      return await model.fields.getAllIdsAndNames();
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_FIELDS_PATH}/{id}/')
  Future<Field> getById(String id) async {
    try {
      Field output = await model.fields.getById(id);
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: '${API_FIELDS_PATH}/{id}/')
  Future<IdResponse> update(String id, Field field) async {
    try {
      await field.validate(id != field.id);
      String output = await model.fields.write(field, id);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_FIELDS_PATH}/${newId}";
}
