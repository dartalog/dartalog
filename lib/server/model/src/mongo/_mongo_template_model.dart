part of model;

class _MongoTemplateModel extends ATemplateModel {
  static final Logger _log = new Logger('_MongoTemplateModel');

  Future<Map<String, api.Template>> getAll() async {
    _log.info("Getting all templates");

    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getTemplatesCollection();

    List results = await collection.find().toList();

    Map<String, api.Template> output = new Map<String, api.Template>();
    con.release(); // Release the connection before calling another model function, so that we don't end up opening multiple connections unnecessarily

    Map<String, api.Field> fields = await Model.fields.getAll();
    for (var result in results) {
      mongo.ObjectId id = result["_id"];
      String str_id = id.toJson();
      output[str_id] = _createTemplate(result, fields);
    }
    return output;
  }

  static Future<Map> getByUUID(String uuid) {
    if (!isUuid(uuid)) {
      throw new ValidationException("Not a valid UUID: ${uuid}");
    }

    _log.info("Getting specific field by UUID: ${uuid}");
    mysql.ConnectionPool pool = Model.getConnectionPool();
    return pool.query(_GET_TEMPLATE_BY_UUID.replaceAll(
        _AModel._UUID_REPLACEMENT_STRING, uuid.replaceAll("-", ""))).then((
        Stream str) {
      return str.toList().then((results) {
        if (results.length == 0) {
          return null;
        } else {
          dynamic result = results[0];
          return new Template.fromData(result);
        }
      });
    });
  }


  Future write(api.Template template, [String id = null]) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getTemplatesCollection();


    if (tools.isNullOrWhitespace(id)) {
      Map data = _createMap(template);
      dynamic result = collection.insert(data);
      return result.toString();
    } else {
      mongo.ObjectId obj_id = mongo.ObjectId.parse(id);

      var data = await collection.findOne({"_id": obj_id});
      if (data == null) {
        throw new Exception("Template not found ${id}");
      }
      _updateMap(template, data);
      await collection.save(data);
      return id;
    }
    con.release();
  }

  api.Template _createTemplate(Map data, Map<String,api.Field> fields) {
    api.Template template = new api.Template();
    template.name = data["name"];
    for(mongo.DbRef field_ref in data["fields"]) {
      if(!fields.containsKey(field_ref.id.toJson())) {
        throw new Exception();
      }
      template.fields[field_ref.id.toJson()] = fields[field_ref.id.toJson()];
    }
    return template;
  }

  Map _createMap(api.Template template) {
    Map data = new Map();
    _updateMap(template, data);
    return data;
  }

  void _updateMap(api.Template template, Map data) {
    data["name"] = template.name;

    List<mongo.DbRef> field_ids = new List<mongo.DbRef>();
    for(String field_string in template.fields.keys) {
      field_ids.add(new mongo.DbRef(_MongoDatabase._TEMPLATES_MONGO_COLLECTION,mongo.ObjectId.parse(field_string)));
    }

    data["fields"] = field_ids;
  }

}