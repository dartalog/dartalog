part of model;

class FieldModel extends _AModel {
  static final Logger _log = new Logger('FieldModel');

  FieldModel();

  Future<mongo.DbCollection> getCollection() async {
    mongo.Db db = await Model.setUpDataAdapter();
    return db.collection("fields");
  }

  Future<Map<String,String>> getAllIDsAndNames() async {
    _log.info("Getting all field IDs and names ");

    mongo.DbCollection collection = Model._db.collection("fields");

    List results = await collection.find().toList();

    Map<String,String> output = new Map<String,String>();
    for (var result in results) {
      output[tools.formatUuid(result.uuid)] = result.name;
    }
    return output;
  }

  Future<Map<String,Field>> getAll() async {
    _log.info("Getting all fields");

    mongo.DbCollection collection = await getCollection();

    List results = await collection.find().toList();

    Map<String,Field> output = new Map<String,Field>();
    for (var result in results) {
      mongo.ObjectId id = result["_id"];
      String str_id = id.toJson();
      output[str_id] = (new Field.fromData(result));
    }
    return output;
  }

  Future<Field> getByID(String id) {
    _log.info("Getting specific field by ID: ${id}");

  }

  Future write(Field field, [String id = null]) async {
    mongo.DbCollection collection = await getCollection();


    if(tools.isNullOrWhitespace(id)) {
      Map<String, dynamic> data = field.toMap();
      dynamic result = collection.insert(data);
      return result.toString();
    } else {
      var data = await collection.findOne({"_id": id});
      field.setData(data);
      await collection.save(data);
      return id;
    }

 }

//  Future write(String name, String title, String type, String pattern) {
//    return _write(this.createFieldMap(name, title, type, pattern));
//  }


}