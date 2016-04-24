part of model;

class _MongoItemTypeModel extends AItemTypeModel {
  static final Logger _log = new Logger('_MongoTemplateModel');

  Future<Map<String, api.ItemType>> getAll() async {
    _log.info("Getting all presets");

    return await _getFromDb(null);
  }

  Future<api.ItemType> get(String id) async {
    _log.info("Getting specific field by ID: ${id}");
    Map results = await _getFromDb(mongo.where.id(mongo.ObjectId.parse(id)));

    if(results.length==0) {
      return null;
    }

    return results[results.keys.first];
  }

  Future<Map<String, api.ItemType>> _getFromDb(dynamic selector) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getTemplatesCollection();

    List results = await collection.find(selector).toList();

    Map<String, api.ItemType> output = new Map<String, api.ItemType>();
    con.release(); // Release the connection before calling another model function, so that we don't end up opening multiple connections unnecessarily

    Map<String, api.Field> availableFields = await fields.getAll();
    for (var result in results) {
      mongo.ObjectId id = result["_id"];
      String str_id = id.toJson();
      output[str_id] = _createTemplate(result, availableFields);
    }
    return output;

  }

  Future write(api.ItemType template, [String id = null, bool allowIdInsert = false]) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getTemplatesCollection();


    Map data;
    if(!tools.isNullOrWhitespace(id)) {
      mongo.ObjectId obj_id = mongo.ObjectId.parse(id);
      data = await collection.findOne({"_id": obj_id});

      if(!allowIdInsert&&data==null) {
        throw new Exception("Item Type not found ${template}");
      }
    }
    if(data==null) {
      data = _createMap(template);
      if(allowIdInsert&&!tools.isNullOrWhitespace(id)) {
        data["_id"] = mongo.ObjectId.parse(id);
      }
      dynamic result = await collection.insert(data);
      return;
    }

    _updateMap(template, data);
    await collection.save(data);

    con.release();
  }

  api.ItemType _createTemplate(Map data, Map<String,api.Field> fields) {
    api.ItemType template = new api.ItemType();
    template.name = data["name"];
    for(mongo.DbRef field_ref in data["fields"]) {
      template.fields.add(field_ref.id.toJson());
    }
    return template;
  }

  Map _createMap(api.ItemType template) {
    Map data = new Map();
    _updateMap(template, data);
    return data;
  }

  void _updateMap(api.ItemType template, Map data) {
    data["name"] = template.name;

    List<mongo.DbRef> field_ids = new List<mongo.DbRef>();
    for(String field_string in template.fields) {
      field_ids.add(new mongo.DbRef(_MongoDatabase._FIELDS_MONGO_COLLECTION,mongo.ObjectId.parse(field_string)));
    }

    data["fields"] = field_ids;
  }

}