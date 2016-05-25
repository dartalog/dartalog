part of api;

class ItemResource extends AResource {
  static final Logger _log = new Logger('ItemResource');

  Logger _GetLogger() {
    return _log;
  }

  @ApiMethod(path: 'items/')
  Future<List<ItemListing>> getAll() async {
    try {
      List<Item> output = await model.items.getAll();
      return ItemListing.convertList(output);
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: 'items/{id}/')
  Future<Item> get(String id, {String expand}) async {
    try {
      Item output = await model.items.get(id);

      if(output==null) {
        throw new NotFoundError("Item '${id}' not found");
      }

      if(!isNullOrWhitespace(expand)) {
        List<String> expands = expand.split(",");
        if (expands.contains("type")) {
          output.type = await model.itemTypes.get(output.typeId);
          if (output.type == null) {
            throw new InternalServerError(
                "Item type '${output.typeId}' specified for item not found");
          }
          if (expands.contains("type.fields")) {
            output.type.fields =
            await model.fields.getAllForIDs(output.type.fieldIds);
          }
        }
      }
      return output;
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'POST', path: 'items/')
  Future<IdResponse> create(Item item) async {
    try {
      await item.validate(true);
      if(isNullOrWhitespace(item.id))
        item.id = await generateUniqueId(item);

      String output = await model.items.write(item);
      return new IdResponse.fromId(output);
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: 'items/{id}/')
  Future<IdResponse> update(String id, Item item) async {
    try {
      await item.validate(id!=item.id);
      String output = await model.items.write(item,id);
      return new IdResponse.fromId(output);
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'DELETE', path: 'items/{id}/')
  Future<VoidMessage> delete(String id) async {
    try {
      await model.items.delete(id);
    } catch(e,st) {
      _HandleException(e, st);
    }
  }


  static final RegExp LEGAL_ID_CHARACTERS = new RegExp("[a-zA-Z0-9_]");
  static Future<String> generateUniqueId(Item item) async {
    if(isNullOrWhitespace(item.name))
      throw new model.InvalidInputException("Name required to generate unique ID");

    StringBuffer output = new StringBuffer();
    String lastChar = "_";
    for(int i = 0; i < item.name.length;i++) {
      String char = item.name.substring(i,i+1);
      switch(char) {
        case " ":
        case ":":
          if(lastChar!="_") {
            lastChar = "_";
            output.write(lastChar);
          }
          break;
        default:
          if(LEGAL_ID_CHARACTERS.hasMatch(char)) {
            lastChar = char.toLowerCase();
            output.write(lastChar);
          }
          break;
      }
    }

    if(output.length==0)
      throw new model.InvalidInputException("Could not generate safe ID from name '${item.name}'");

    String base_name = output.toString();
    String testName = base_name;
    Item testItem = await model.items.get(base_name);
    int i = 1;
    while(testItem!=null) {
      testName = "${base_name}_${i}";
      i++;
      testItem = await model.items.get(testName);
    }
    return testName;
  }

}