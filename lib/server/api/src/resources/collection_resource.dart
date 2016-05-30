part of api;

class CollectionResource extends AIdResource<Collection> {
  static final Logger _log = new Logger('CollectionResource');
  Logger get _logger => _log;

  model.AIdNameBasedModel<Collection> get idModel => model.collections;

  @ApiMethod(method: 'POST', path: '${API_COLLECTIONS_PATH}/')
  Future<IdResponse> create(Collection collection) => _createWithCatch(collection);

  @ApiMethod(path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<Collection> getById(String id)  => _getByIdWithCatch(id);

  @ApiMethod(path: '${API_COLLECTIONS_PATH}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => _getAllIdsAndNamesWithCatch();

  @ApiMethod(method: 'PUT', path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<IdResponse> update(String id, Collection collection) => _updateWithCatch(id, collection);

  @ApiMethod(method: 'DELETE', path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _deleteWithCatch(id);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_COLLECTIONS_PATH}/${newId}";
}
