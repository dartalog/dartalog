part of api;

class ItemResource extends AIdResource<Item> {
  static final Logger _log = new Logger('ItemResource');
  Logger get _logger => _log;
  static const _API_PATH = API_ITEMS_PATH;

  @ApiResource()
  final ItemCopyResource copies = new ItemCopyResource ();

  model.AIdNameBasedModel<Item> get idModel => model.items;

  @ApiMethod(method: 'POST', path: '${_API_PATH}/')
  Future<ItemCopyId> createItemWithCopy(CreateItemRequest newItem) =>
      _catchExceptions(model.items.createWithCopy(newItem.newItem, newItem.collectionId, newItem.uniqueId));

  // Created only to satisfy the interface; should not be used, as creating acopy with each item should be required
  Future<IdResponse> create(Item item) => _createWithCatch(item);

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

  @ApiMethod(path: 'search/{query}/')
  Future<List<ItemListingResponse>> search(String query) =>
      _catchExceptions(_search(query));
  Future<List<ItemListingResponse>> _search(String query) async {
    return ItemListingResponse.convertList(await model.items.search(query));
  }

  @ApiMethod(method: 'PUT', path: '${_API_PATH}/{id}/')
  Future<IdResponse> update(String id, Item item) => _updateWithCatch(id, item);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_ITEMS_PATH}/${newId}";


}
