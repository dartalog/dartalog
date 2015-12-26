part of model;

class _MongoItemModel extends AItemModel  {
  static final Logger _log = new Logger('_MongoItemModel');


  Future<Map<String,api.Item>> getAll() async {
    _log.info("Getting all items");
    return await _getFromDb(null);
  }

  Future<api.Item> get(String id) async {
    _log.info("Getting specific item by ID: ${id}");
    Map results = await _getFromDb(mongo.where.id(mongo.ObjectId.parse(id)));

    if(results.length==0) {
      return null;
    }

    return results[results.keys.first];
  }

  Future<Map<String, api.Item>> _getFromDb(dynamic selector) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getItemsCollection();

    List results = await collection.find(selector).toList();

    Map<String,api.Item> output = new Map<String,api.Item>();
    for (var result in results) {
      mongo.ObjectId id = result["_id"];
      String str_id = id.toJson();
      output[str_id] = (_createItem(result));
    }
    con.release();
    return output;
  }

  Future write(api.Item item, [String id = null]) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getItemsCollection();

    if(tools.isNullOrWhitespace(id)) {
      Map<String, dynamic> data = _createMap(item);
      dynamic result = collection.insert(data);
      return result.toString();
    } else {
      mongo.ObjectId obj_id = mongo.ObjectId.parse(id);

      var data = await collection.findOne({"_id": obj_id});
      if(data==null) {
        throw new Exception("Item not found ${obj_id.toJson()}");
      }
      _updateMap(item,data);
      await collection.save(data);
      con.release();
      return id;
    }
  }


  api.Item _createItem(Map data) {
    api.Item output = new api.Item();
    mongo.DbRef template_ref = data["template"];
    output.template = template_ref.id.toJson();

    for(String field_id in data["values"].keys){

      output.fieldValues[field_id] = data["values"][field_id]["value"];
    }
    return output;
  }

  Map _createMap(api.Item item) {
    Map data = new Map();
    _updateMap(item,data);
    return data;
  }

  void _updateMap(api.Item item, Map data) {
    data["template"] = new mongo.DbRef(_MongoDatabase._TEMPLATES_MONGO_COLLECTION,mongo.ObjectId.parse(item.template));

    Map values = new Map();
    for(String field_id in item.fieldValues.keys) {
      mongo.DbRef field_ref =  new mongo.DbRef(_MongoDatabase._FIELDS_MONGO_COLLECTION,mongo.ObjectId.parse(field_id));
      values[field_id] = {'ref' : field_ref, 'value': item.fieldValues[field_id]};
    }
    data["values"] = values;
  }
}