part of api;

class ItemResource extends AIdResource<Item> {
  static final Logger _log = new Logger('ItemResource');
  Logger get _logger => _log;
  static const _API_PATH = API_ITEMS_PATH;

  @ApiResource()
  final ItemCopyResource copies = new ItemCopyResource();

  model.AIdNameBasedModel<Item> get idModel => model.items;

  @ApiMethod(method: 'POST', path: '${_API_PATH}/')
  Future<ItemCopyId> createItemWithCopy(CreateItemRequest newItem) async {
    List<List<int>> files = null;
    if (newItem.files != null) {
      files = convertFiles(newItem.files);
    }
    return await _catchExceptionsAwait(() => model.items.createWithCopy(
        newItem.item, newItem.collectionId,
        uniqueId: newItem.uniqueId, files: files));
  }

  // Created only to satisfy the interface; should not be used, as creating a copy with each item should be required
  Future<IdResponse> create(Item item) => _createWithCatch(item);

  @ApiMethod(method: 'DELETE', path: '${_API_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _deleteWithCatch(id);

  Future<List<IdNamePair>> getAllIdsAndNames() =>
      _getAllIdsAndNamesWithCatch();

  @ApiMethod(path: '${_API_PATH}/')
  Future<List<ItemSummary>> getVisibleListings(
          {int offset: 0}) =>
      _catchExceptionsAwait(() async =>
      ItemSummary.convertList(await model.items.getVisible()));

  @ApiMethod(path: '${_API_PATH}/{id}/')
  Future<Item> getById(String id,
          {bool includeType: false,
          bool includeFields: false,
          bool includeCopies: false,
          bool includeCopyCollection: false}) =>
      _catchExceptionsAwait(() => model.items.getById(id,
          includeType: includeType,
          includeCopies: includeCopies,
          includeFields: includeFields,
          includeCopyCollection: includeCopyCollection));

  @ApiMethod(path: 'search/{query}/')
  Future<List<ItemSummary>> searchVisible(String query) =>
      _catchExceptionsAwait(() async =>
          ItemSummary.convertList(await model.items.searchVisible(query)));

  Future<IdResponse> update(String id, Item item) => _updateWithCatch(id, item);

  @ApiMethod(method: 'PUT', path: '${_API_PATH}/{id}/')
  Future<IdResponse> updateItem(String id, UpdateItemRequest item) async {
    List<List<int>> files = null;
    if (item.files != null) {
      files = convertFiles(item.files);
    }
    String output = await _catchExceptionsAwait(
        () => model.items.update(id, item.item, files: files));
    return new IdResponse.fromId(id, _generateRedirect(id));
  }

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_ITEMS_PATH}/${newId}";
}
