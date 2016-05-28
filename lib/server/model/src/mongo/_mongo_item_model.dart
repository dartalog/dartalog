part of model;

class _MongoItemModel extends AItemModel {
  static final Logger _log = new Logger('_MongoItemModel');

  Future delete(String id) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await con.getItemsCollection();
      if (tools.isNullOrWhitespace(id)) {
        throw new InvalidInputException("ID is required");
      }
      dynamic criteria;
      criteria = mongo.where.eq("id", id);
      await collection.remove(criteria);
    } finally {
      con.release();
    }
  }

  Future<api.Item> get(String id) async {
    _log.info("Getting specific item by ID: ${id}");
    List results = await _getFromDb(mongo.where.eq("id", id));

    if (results.length == 0) {
      return null;
    }

    return results.first;
  }

  Future<List<api.Item>> getAll() async {
    _log.info("Getting all items");
    return await _getFromDb(null);
  }

  Future write(api.Item item, [String id = null]) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await con.getItemsCollection();

      if (tools.isNullOrWhitespace(id)) {
        Map<String, dynamic> data = _createMap(item);
        await collection.insert(data);
      } else {
        var data = await collection.findOne({"id": id});
        if (data == null) {
          throw new Exception("Item not found ${id}");
        }
        _updateMap(item, data);
        await collection.save(data);
      }
      return item.id;
    } finally {
      con.release();
    }
  }

  api.Item _createItem(Map data) {
    api.Item output = new api.Item();

    output.id = data['id'];
    output.name = data['name'];
    output.typeId = data['typeId'];

    output.values = data["values"];

    return output;
  }

  Map _createMap(api.Item item) {
    Map data = new Map();
    _updateMap(item, data);
    return data;
  }

  Future<List<api.Item>> _getFromDb(dynamic selector) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await con.getItemsCollection();

      List results = await collection.find(selector).toList();

      List<api.Item> output = new List<api.Item>();
      for (var result in results) {
        output.add(_createItem(result));
      }
      return output;
    } finally {
      con.release();
    }
  }

  void _updateMap(api.Item item, Map data) {
    data["id"] = item.id;
    data["name"] = item.name;
    data["typeId"] = item.typeId;
    data["values"] = item.values;
  }
}
