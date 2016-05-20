part of api;

class ItemResource extends AResource {
  static final Logger _log = new Logger('ItemResource');

  Logger _GetLogger() {
    return _log;
  }

  @ApiMethod(path: 'items/')
  Future<List<Item>> getAll() async {
    try {
      List<Item> output = await model.items.getAll();
      return output;
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: 'items/{id}/')
  Future<ItemResponse> get(String id) async {
    try {
      ItemResponse response = new ItemResponse();
      response.item = await model.items.get(id);
      if(response.item==null) {
        throw new NotFoundError("Item not found");
      }
      response.type = await model.itemTypes.get(response.item.type);
      if(response.type==null) {
        throw new InternalServerError("Template specified for item not found");
      }

      return response;
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'POST', path: 'items/')
  Future<VoidMessage> create(Item item) async {
    try {
      String output = await model.items.write(item);
      //return new UuidResponse.fromUuid(output);
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: 'items/{id}/')
  Future<VoidMessage> update(String id, Item item) async {
    try {
    String output = await model.items.write(item,id);
    //return new UuidResponse.fromUuid(output);
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

}