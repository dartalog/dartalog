part of api;

class ItemResource extends AResource {
  static final Logger _log = new Logger('ItemResource');

  Logger _GetLogger() {
    return _log;
  }

  @ApiMethod(path: 'items/')
  Future<Map<String,Item>> getAll() async {
    try {
      dynamic output = await model.items.getAll();
      return output;
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: 'items/{uuid}/')
  Future<ItemResponse> get(String uuid) async {
    try {
      ItemResponse response = new ItemResponse();
      response.item = await model.items.get(uuid);
      if(response.item==null) {
        throw new NotFoundError("Item not found");
      }
      response.template = await model.itemTypes.get(response.item.template);
      if(response.template==null) {
        throw new InternalServerError("Template specified for item not found");
      }
      response.fields = await model.fields.getAllForIDs(response.template.fields);
      for(String field in response.template.fields) {
        if(!response.fields.containsKey(field)) {
          throw new InternalServerError("Field specified for template not found");
        }
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

  @ApiMethod(method: 'PUT', path: 'items/{uuid}/')
  Future<VoidMessage> update(String uuid, Item item) async {
    try {
    String output = await model.items.write(item,uuid);
    //return new UuidResponse.fromUuid(output);
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

}