part of api;

class CollectionResource extends AIdResource<Collection> {
  static final Logger _log = new Logger('CollectionResource');
  Logger get _logger => _log;

  model.AIdModel<Collection> get idModel => model.itemCollections;

  @ApiMethod(method: 'POST', path: '${API_COLLECTIONS_PATH}/')
  Future<IdResponse> create(Collection collection) => _create(collection);

  @ApiMethod(path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<Collection> getById(String id)  => _getById(id);

  @ApiMethod(path: '${API_COLLECTIONS_PATH}/')
  Future<List<IdNamePairResponse>> getAllIdsAndNames() => _getAllIdsAndNames();

  @ApiMethod(method: 'PUT', path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<IdResponse> update(String id, Collection collection) => _update(id, collection);

  @ApiMethod(method: 'DELETE', path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _delete(id);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_COLLECTIONS_PATH}/${newId}";
}
