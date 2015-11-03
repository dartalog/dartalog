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

  Future<List<Field>> getAll() async {
    _log.info("Getting all fields");

    mongo.DbCollection collection = await getCollection();

    List results = await collection.find().toList();

    List<Field> output = new List<Field>();
    for (var result in results) {
      output.add(new Field.fromData(result));
    }
    return output;
  }

  Future<Field> getByUUID(String uuid) {
    if(!isUuid(uuid)) {
      throw new ValidationException("Not a valid UUID: ${uuid}");
    }

    _log.info("Getting specific field by UUID: ${uuid}");

  }

  Future write(Field field, [String uuid = null]) async {
    mongo.DbCollection collection = await getCollection();


    if(tools.isNullOrWhitespace(uuid)) {
      Map<String, dynamic> data = field.toMap();
      data["uuid"] = tools.generateUuid();
      collection.insert(data);
      return data["uuid"];
    } else {
      if(!tools.isUuid(uuid)) {
        throw new Exception("Invalid UUID");
      }
      var data = await collection.findOne({"uuid": uuid});
      field.setData(data);
      await collection.save(data);
      return uuid;
    }

 }

//  Future write(String name, String title, String type, String pattern) {
//    return _write(this.createFieldMap(name, title, type, pattern));
//  }


}