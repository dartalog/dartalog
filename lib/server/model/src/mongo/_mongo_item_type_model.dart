part of model;

class _MongoItemTypeModel extends AItemTypeModel {
  static final Logger _log = new Logger('_MongoTemplateModel');

  Future<api.ItemType> get(String id) async {
    _log.info("Getting specific field by id: ${id}");

    dynamic criteria;
    criteria = mongo.where.eq("id", id);

    List results = await _getFromDb(criteria);

    if (results.length == 0) {
      return null;
    }

    return results.first;
  }

  Future<List<api.ItemType>> getAll() async {
    _log.info("Getting all presets");

    return await _getFromDb(null);
  }

  Future write(api.ItemType itemType, [String id = null]) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await con.getItemTypesCollection();

      Map data;
      if (!tools.isNullOrWhitespace(id)) {
        data = await collection.findOne({"id": id});
      }
      if (data == null) {
        data = _createMap(itemType);
        dynamic result = await collection.insert(data);
        return;
      }

      _updateMap(itemType, data);
      await collection.save(data);
    } finally {
      con.release();
    }
  }

  api.ItemType _createItemType(Map data) {
    api.ItemType template = new api.ItemType();
    template.id = data["id"];
    template.name = data["name"];
    template.fieldIds = data["fieldIds"];
    return template;
  }

  Map _createMap(api.ItemType template) {
    Map data = new Map();
    _updateMap(template, data);
    return data;
  }

  Future<List<api.ItemType>> _getFromDb(dynamic selector) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    List results;
    try {
      mongo.DbCollection collection = await con.getItemTypesCollection();

      results = await collection.find(selector).toList();
    } finally {
      con.release(); // Release the connection before calling another model function, so that we don't end up opening multiple connections unnecessarily
    }

    List<api.ItemType> output = new List<api.ItemType>();
    for (var result in results) {
      output.add(_createItemType(result));
    }
    return output;
  }

  void _updateMap(api.ItemType template, Map data) {
    data["id"] = template.id;
    data["name"] = template.name;
    data["fieldIds"] = template.fieldIds;
  }
}
