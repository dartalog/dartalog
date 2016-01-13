part of api;

class ItemTypeResource {
  static final Logger _log = new Logger('ItemTypeResource');

  @ApiMethod(path: 'item_types/')
  Future<Map<String,ItemType>> getAll() async {
    try {
      Map<String,ItemType> output = await Model.templates.getAll();
      return output;
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(path: 'item_types/{uuid}/')
  Future<ItemTypeResponse> get(String uuid) async {
    try {
      ItemTypeResponse output = new ItemTypeResponse();
      output.itemType = await Model.templates.get(uuid);
      output.fields = await Model.fields.getAllForIDs(output.itemType.fields);
      return output;
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(method: 'POST', path: 'item_types/')
  Future<VoidMessage> create(ItemType template) async {
    try {
      template.validate();
      await Model.templates.write(template);
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(method: 'PUT', path: 'item_types/{uuid}/')
  Future<VoidMessage> update(String uuid, ItemType template) async {
    try {
      template.validate();
      String output = await Model.templates.write(template, uuid);
      //return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }
}