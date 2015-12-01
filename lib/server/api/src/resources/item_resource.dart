part of api;

class ItemResource {
  static final Logger _log = new Logger('ItemResource');

  @ApiMethod(path: 'items/')
  Future<Map<String,Item>> getAll() async {
    try {
      dynamic output = await Model.items.getAll();
      return output;
    } catch(e,st) {
     _log.severe(e,st);
      throw e;
    }
  }

  @ApiMethod(path: 'items/{uuid}/')
  Future<Item> get(String uuid) async {
    try {
    dynamic output = await Model.items.getByUUID(uuid);
    return output;
    } catch(e,st) {
      _log.severe(e,st);
      throw e;
    }
  }

  @ApiMethod(method: 'POST', path: 'items/')
  Future<VoidMessage> create(Item item) async {
    try {
      String output = await Model.items.write(item);
      //return new UuidResponse.fromUuid(output);
    } catch(e,st) {
    _log.severe(e,st);
    throw e;
    }
  }

  @ApiMethod(method: 'PUT', path: 'items/{uuid}/')
  Future<VoidMessage> update(String uuid, Item item) async {
    try {
    String output = await Model.items.write(item,uuid);
    //return new UuidResponse.fromUuid(output);
    } catch(e,st) {
      _log.severe(e,st);
      throw e;
    }
  }

}