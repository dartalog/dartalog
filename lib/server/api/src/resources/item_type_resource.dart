part of api;

class ItemTypeResource extends AResource {
  static final Logger _log = new Logger('ItemTypeResource');
  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${API_ITEM_TYPES_PATH}/')
  Future<IdResponse> create(ItemType itemType) async {
    try {
      await itemType.validate(true);
      String output = await model.itemTypes.write(itemType);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<ItemType> getById(String id, {String expand}) async {
    try {
      ItemType output = await model.itemTypes.getById(id);
      if (output == null)
        throw new NotFoundError("Item type '${id}' not found");
      if (expand == "fields") {
        output.fields = await model.fields.getByIds(output.fieldIds);
      }
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_ITEM_TYPES_PATH}/')
  Future<List<IdNamePair>> getAllIdsAndNames() async {
    try {
      return await model.itemTypes.getAllIdsAndNames();
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<IdResponse> update(String id, ItemType itemType) async {
    try {
      await itemType.validate(id != itemType.id);
      String output = await model.itemTypes.write(itemType, id);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_ITEM_TYPES_PATH}/${newId}";
}
