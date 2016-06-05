part of api;

class ItemResource extends AIdResource<Item> {
  static final Logger _log = new Logger('ItemResource');
  Logger get _logger => _log;
  static const _API_PATH = API_ITEMS_PATH;

  @ApiResource()
  final ItemCopyResource copies = new ItemCopyResource ();

  model.AIdNameBasedModel<Item> get idModel => model.items;

  @ApiMethod(method: 'POST', path: '${_API_PATH}/')
  Future<IdResponse> create(Item item) => _createWithCatch(item);

  @ApiMethod(method: 'POST', path: '${_API_PATH}/')
  Future<IdResponse> createWithCopy(Item item, ) async {
    _catchExceptions()
  }


  @ApiMethod(method: 'DELETE', path: '${_API_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _deleteWithCatch(id);

  Future<List<IdNamePair>> getAllIdsAndNames() => _getAllIdsAndNamesWithCatch();

  @ApiMethod(path: '${_API_PATH}/')
  Future<List<ItemListingResponse>> getAllListings() =>
      _catchExceptions(_getAllListings());
  Future<List<ItemListingResponse>> _getAllListings() async =>
      ItemListingResponse.convertList(await model.items.getAll());

  @ApiMethod(path: '${_API_PATH}/{id}/')
  Future<Item> getById(String id, {bool includeType: false, bool includeFields: false, bool includeCopies:false}) =>
      _catchExceptions(model.items.getById(id, includeType: includeType, includeCopies: includeCopies, includeFields: includeFields));

  @ApiMethod(method: 'PUT', path: '${_API_PATH}/{id}/')
  Future<IdResponse> update(String id, Item item) => _updateWithCatch(id, item);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_ITEMS_PATH}/${newId}";


}
