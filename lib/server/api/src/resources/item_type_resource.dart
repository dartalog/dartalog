part of api;

class ItemTypeResource extends AResource {
  static final Logger _log = new Logger('ItemTypeResource');

  Logger _GetLogger() {
    return _log;
  }

  @ApiMethod(path: 'item_types/')
  Future<List<ItemType>> getAll() async {
    try {
      List<ItemType> output = await model.itemTypes.getAll();
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: 'item_types/{id}/')
  Future<ItemTypeResponse> get(String id) async {
    try {
      ItemTypeResponse output = new ItemTypeResponse();
      output.itemType = await model.itemTypes.get(id);
      output.fields = await model.fields.getAllForIDs(output.itemType.fields);
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'POST', path: 'item_types/')
  Future<VoidMessage> create(ItemType itemType) async {
    try {
      await itemType.validate(true);
      await model.itemTypes.write(itemType);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: 'item_types/{id}/')
  Future<VoidMessage> update(String id, ItemType itemType) async {
    try {
      await itemType.validate(id!=itemType.id);
      String output = await model.itemTypes.write(itemType, id);
      //return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }
}