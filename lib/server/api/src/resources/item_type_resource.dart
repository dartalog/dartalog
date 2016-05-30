part of api;

class ItemTypeResource extends AIdResource<ItemType> {
  static final Logger _log = new Logger('ItemTypeResource');
  Logger get _logger => _log;

  model.AIdModel<ItemType> get idModel => model.itemTypes;

  @ApiMethod(method: 'POST', path: '${API_ITEM_TYPES_PATH}/')
  Future<IdResponse> create(ItemType itemType) => _create(itemType);

  @ApiMethod(path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<ItemType> getById(String id, {String expand}) => _catchExceptions(_getById(id, expand: expand));
  Future<ItemType> _getById(String id, {String expand}) async {
    ItemType output = await _getByIdInternal(id);

    if (expand == "fields") {
        output.fields = await model.fields.getByIds(output.fieldIds);
      }
      return output;
  }

  @ApiMethod(path: '${API_ITEM_TYPES_PATH}/')
  Future<List<IdNamePairResponse>> getAllIdsAndNames() => _getAllIdsAndNames();

  @ApiMethod(method: 'PUT', path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<IdResponse> update(String id, ItemType itemType) => _update(id, itemType);

  @ApiMethod(method: 'DELETE', path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _delete(id);


  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_ITEM_TYPES_PATH}/${newId}";
}
