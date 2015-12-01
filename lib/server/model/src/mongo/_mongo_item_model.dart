part of model;

class _MongoItemModel extends AItemModel  {
  static final Logger _log = new Logger('_MongoItemModel');


  Future<Map<String,Item>> getAll() async {
    _log.info("Getting all items");

    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getItemsCollection();

    List results = await collection.find().toList();

    Map<String,Item> output = new Map<String,Item>();
    for (var result in results) {
      mongo.ObjectId id = result["_id"];
      String str_id = id.toJson();
      output[str_id] = (new Item.fromData(result));
    }
    con.release();
    return output;
  }

  static Future<Field> getByID(String id) {
    _log.info("Getting specific field by ID: ${id}");
  }

  Future write(Field field, [String id = null]) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getItemsCollection();


    if(tools.isNullOrWhitespace(id)) {
      Map<String, dynamic> data = field.toMap();
      dynamic result = collection.insert(data);
      return result.toString();
    } else {
      mongo.ObjectId obj_id = mongo.ObjectId.parse(id);

      var data = await collection.findOne({"_id": obj_id});
      if(data==null) {
        throw new Exception("Field not found ${field}");
      }
      field.setData(data);
      await collection.save(data);
      con.release();
      return id;
    }
  }

  Item fromData(dynamic data) {
    this.template = data["template"];
    for(mongo.DbRef field_ref in data["fields"]) {
      this.fields[field_ref.id.toJson()] = fields[field_ref.id.toJson()];
    }
  }

  void setData(dynamic data) {
    List<mongo.DbRef> field_ids = new List<mongo.DbRef>();
    for(String field_string in fields.keys) {
      field_ids.add(new mongo.DbRef(TemplateModel.TEMPLATES_COLLECTION,mongo.ObjectId.parse(field_string)));
    }
    data["template"] = template;
    data["fields"] = field_ids;

  }

}