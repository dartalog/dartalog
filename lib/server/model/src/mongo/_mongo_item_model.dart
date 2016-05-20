part of model;

class _MongoItemModel extends AItemModel  {
  static final Logger _log = new Logger('_MongoItemModel');


  Future<List<api.Item>> getAll() async {
    _log.info("Getting all items");
    return await _getFromDb(null);
  }

  Future<api.Item> get(String id) async {
    _log.info("Getting specific item by ID: ${id}");
    List results = await _getFromDb(mongo.where.id(mongo.ObjectId.parse(id)));

    if(results.length==0) {
      return null;
    }

    return results.first;
  }

  Future<List<api.Item>> _getFromDb(dynamic selector) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getItemsCollection();

    List results = await collection.find(selector).toList();

    List<api.Item> output = new List<api.Item>();
    for (var result in results) {
      output.add(_createItem(result));
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
      var data = await collection.findOne({"id": id});
      if(data==null) {
        throw new Exception("Item not found ${id}");
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


    output.id = template_ref.id.toJson();
    output.name = template_ref.id.toJson();
    output.type = template_ref.id.toJson();

    output.fieldValues = data["values"];

    return output;
  }

  Map _createMap(api.Item item) {
    Map data = new Map();
    _updateMap(item,data);
    return data;
  }

  void _updateMap(api.Item item, Map data) {
    data["id"] = item.id;
    data["name"] = item.name;
    data["type"] = item.type;
    data["values"] = item.fieldValues;
  }



}