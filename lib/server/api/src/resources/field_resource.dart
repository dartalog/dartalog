part of api;

class FieldResource extends AIdResource<Field> {
  static final Logger _log = new Logger('FieldResource');
  model.AIdNameBasedModel<Field> get idModel => model.fields;

  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${API_FIELDS_PATH}/')
  Future<IdResponse> create(Field field) => _createWithCatch(field);

  @ApiMethod(path: '${API_FIELDS_PATH}/')
  Future<PaginatedResponse<IdNamePair>> getAllIdsAndNames({int offset: 0}) => _getAllIdsAndNamesWithCatch(offset: offset);

  @ApiMethod(path: '${API_FIELDS_PATH}/{id}/')
  Future<Field> getById(String id) => _getByIdWithCatch(id);

  @ApiMethod(method: 'PUT', path: '${API_FIELDS_PATH}/{id}/')
  Future<IdResponse> update(String id, Field field) => _updateWithCatch(id, field);

  @ApiMethod(method: 'DELETE', path: '${API_FIELDS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _deleteWithCatch(id);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_FIELDS_PATH}/${newId}";
}
