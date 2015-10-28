part of model;

class FieldModel extends _AModel {
  static final Logger _log = new Logger('FieldModel');

  FieldModel();

  static const String _TABLE_NAME = "fields";

  static const String _GET_ALL_FIELDS = "SELECT HEX(uuid) uuid, name, type, format FROM ${_TABLE_NAME} ORDER BY uuid;";
  static const String _GET_FIELD_BY_UUID = "SELECT HEX(uuid) uuid,  name, type, format FROM ${_TABLE_NAME} WHERE uuid = 0x${_AModel._UUID_REPLACEMENT_STRING}";
  static const String _GET_FIELD_BY_NAME = "SELECT HEX(uuid) uuid,  name, type, format FROM ${_TABLE_NAME} WHERE name = ?";
  static const String _UPDATE_FIELD = "UPDATE ${_TABLE_NAME} SET name = ?, type = ?, format = ? WHERE uuid = 0x${_AModel._UUID_REPLACEMENT_STRING}";
  static const String _INSERT_FIELD = "INSERT INTO ${_TABLE_NAME} (uuid, name, type, format) VALUES (0x${_AModel._UUID_REPLACEMENT_STRING},?, ?, ?);";


  Future<Map<String,String>> getAllIDsAndNames() async {
    _log.info("Getting all field IDs and names ");

    mongo.DbCollection collection = Model._db.collection("fields");

    List results = await collection.find().toList();

    Map<String,String> output = new Map<String,String>();
    for (var result in results) {
      output[formatUuid(result.uuid)] = result.name;
    }
    return output;
  }

  Future<List<Field>> getAll() async {
    _log.info("Getting all fields");

    mongo.Db db = await Model.setUpDataAdapter();

    mongo.DbCollection collection = db.collection("fields");

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

  Future write(Map<String,Object> data, [String uuid = null]) async {

 }

//  Future write(String name, String title, String type, String pattern) {
//    return _write(this.createFieldMap(name, title, type, pattern));
//  }


}