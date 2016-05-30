part of api;

class FieldResource extends AIdResource<Field> {
  static final Logger _log = new Logger('FieldResource');
  model.AIdModel<Field> get idModel => model.fields;

  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${API_FIELDS_PATH}/')
  Future<IdResponse> create(Field field) => _create(field);

  @ApiMethod(path: '${API_FIELDS_PATH}/')
  Future<List<IdNamePairResponse>> getAllIdsAndNames() => _getAllIdsAndNames();

  @ApiMethod(path: '${API_FIELDS_PATH}/{id}/')
  Future<Field> getById(String id) => _getById(id);

  @ApiMethod(method: 'PUT', path: '${API_FIELDS_PATH}/{id}/')
  Future<IdResponse> update(String id, Field field) => _update(id, field);

  @ApiMethod(method: 'DELETE', path: '${API_FIELDS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _delete(id);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_FIELDS_PATH}/${newId}";
}
