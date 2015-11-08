part of model;

class TemplateModel extends _AModel {
  static final Logger _log = new Logger('TemplateModel');

  static const String TEMPLATES_COLLECTION = "templates";

  mongo.Db _db;

  TemplateModel();

  Future<mongo.DbCollection> getCollection() async {
    mongo.Db db = await Model.setUpDataAdapter();
    mongo.DbCollection col = db.collection(TEMPLATES_COLLECTION);
    return col;
  }

  Future<Map<String,Template>> getAll() async {
    _log.info("Getting all templates");

    mongo.DbCollection collection = await getCollection();

    List results = await collection.find().toList();

    Map<String,Template> output = new Map<String,Template>();
    for (var result in results) {
      mongo.ObjectId id = result["_id"];
      String str_id = id.toJson();
      output[str_id] = (new Template.fromData(result));
    }
    return output;
  }

  Future<Map> getByUUID(String uuid) {
    if(!isUuid(uuid)) {
      throw new ValidationException("Not a valid UUID: ${uuid}");
    }

    _log.info("Getting specific field by UUID: ${uuid}");
    mysql.ConnectionPool pool = Model.getConnectionPool();
    return pool.query(_GET_TEMPLATE_BY_UUID.replaceAll(_AModel._UUID_REPLACEMENT_STRING, uuid.replaceAll("-", ""))).then((Stream str) {
      return str.toList().then((results) {
        if(results.length==0) {
          return null;
        } else {
          dynamic result = results[0];
          return new Template.fromData(result);
        }
      });
    });
  }


  Future write(Template template, [String id = null]) async {
    mongo.DbCollection collection = await getCollection();


    if(tools.isNullOrWhitespace(id)) {
      Map<String, dynamic> data = template.toMap();
      dynamic result = collection.insert(data);
      return result.toString();
    } else {
      mongo.ObjectId obj_id = mongo.ObjectId.parse(id);

      var data = await collection.findOne({"_id": obj_id});
      if(data==null) {
        throw new Exception("Template not found ${id}");
      }
      template.setData(data);
      await collection.save(data);
  return id;
}

}

  Map<String, Object> _createFieldMap(dynamic data) {
    Map<String, Object> output = new Map<String, Object>();

    //output[FIELD_UUID] = formatUuid(data.uuid);
    output["title"] = data.title;
    output["properties"] = new List();

    return output;

  }

  Map<String, Object> createFieldMap(String title) {
    Map<String, Object> output = new Map<String, Object>();

    output["title"] = title;
    output["properties"] = new List();


    return output;
  }

}