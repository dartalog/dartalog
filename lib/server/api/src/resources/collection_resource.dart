part of api;

class CollectionResource extends AResource {
  static final Logger _log = new Logger('CollectionResource');
  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${API_COLLECTIONS_PATH}/')
  Future<IdResponse> create(Collection collection) async {
    try {
      await collection.validate(true);
      String output = await model.itemCollections.write(collection);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<Collection> getById(String id, {String expand}) async {
    try {
      Collection output = await model.itemCollections.getById(id);
      if (output == null)
        throw new NotFoundError("Collection '${id}' not found");
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_COLLECTIONS_PATH}/')
  Future<List<IdNamePair>> getAllIdsAndNames() async {
    try {
      return await model.itemCollections.getAllIdsAndNames();
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<IdResponse> update(String id, Collection collection) async {
    try {
      await collection.validate(id != collection.id);
      String output = await model.itemCollections.write(collection, id);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_COLLECTIONS_PATH}/${newId}";
}
