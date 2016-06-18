part of api;

class ItemTypeResource extends AIdResource<ItemType> {
  static final Logger _log = new Logger('ItemTypeResource');
  Logger get _logger => _log;

  model.ItemTypeModel get idModel => model.itemTypes;

  @ApiMethod(method: 'POST', path: '${API_ITEM_TYPES_PATH}/')
  Future<IdResponse> create(ItemType itemType) => _createWithCatch(itemType);

  @ApiMethod(path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<ItemType> getById(String id, {bool includeFields: false}) =>
      _catchExceptionsAwait(() => idModel.getById(id, includeFields: includeFields));

  @ApiMethod(path: '${API_ITEM_TYPES_PATH}/')
  Future<PaginatedResponse<IdNamePair>> getAllIdsAndNames({int offset: 0}) => _getAllIdsAndNamesWithCatch(offset: offset);

  @ApiMethod(method: 'PUT', path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<IdResponse> update(String id, ItemType itemType) =>
      _updateWithCatch(id, itemType);

  @ApiMethod(method: 'DELETE', path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _deleteWithCatch(id);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_ITEM_TYPES_PATH}/${newId}";
}
