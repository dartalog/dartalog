part of model;

class FieldModel extends _AModel {
  static final Logger _log = new Logger('FieldModel');

  //ADatabase _db;
  //ANoSqlDatabase get _nsdb => this._db;
  //mongo.Db _db;

  FieldModel();

  static const String _TABLE_NAME = "fields";

  static const String _GET_ALL_FIELDS = "SELECT HEX(uuid) uuid, name, type, format FROM ${_TABLE_NAME} ORDER BY uuid;";
  static const String _GET_FIELD_BY_UUID = "SELECT HEX(uuid) uuid,  name, type, format FROM ${_TABLE_NAME} WHERE uuid = 0x${_AModel._UUID_REPLACEMENT_STRING}";
  static const String _GET_FIELD_BY_NAME = "SELECT HEX(uuid) uuid,  name, type, format FROM ${_TABLE_NAME} WHERE name = ?";
  static const String _UPDATE_FIELD = "UPDATE ${_TABLE_NAME} SET name = ?, type = ?, format = ? WHERE uuid = 0x${_AModel._UUID_REPLACEMENT_STRING}";
  static const String _INSERT_FIELD = "INSERT INTO ${_TABLE_NAME} (uuid, name, type, format) VALUES (0x${_AModel._UUID_REPLACEMENT_STRING},?, ?, ?);";


  Future<Map<String,String>> getAllIDsAndNames() async {
    _log.info("Getting all field IDs and names ");

    mysql.ConnectionPool pool = Model.getConnectionPool();

    Stream str = await pool.query(FieldModel._GET_ALL_FIELDS);
    List results = await str.toList();

    Map<String,String> output = new Map<String,String>();
    for (var result in results) {
      output[formatUuid(result.uuid)] = result.name;
    }
    return output;
  }

  Future<List<Field>> getAll() async {
    _log.info("Getting all fields");

    mysql.ConnectionPool pool = Model.getConnectionPool();

    Stream str = await pool.query(FieldModel._GET_ALL_FIELDS);
    List results = await str.toList();

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
    mysql.ConnectionPool pool = Model.getConnectionPool();

    return pool.query(_GET_FIELD_BY_UUID.replaceAll(_AModel._UUID_REPLACEMENT_STRING, uuid.replaceAll("-", ""))).then((Stream str) {
      return str.toList().then((results) {
        if(results.length==0) {
          return null;
        } else {
          dynamic result = results[0];
          return new Field.fromData(result);
        }
      });
    });
  }

  Future write(Map<String,Object> data, [String uuid = null]) async {
//    mongo.DbCollection col = this._db.collection("fields");
//    return this._db.open().then((_) {
//      if(data.containsKey("id")) {
//        data.remove("id");
//      }
//      col.insert(data);
//    });
    mysql.ConnectionPool pool = Model.getConnectionPool();
    String query;
    if(uuid!=null) {
      if(!isUuid(uuid)) {
        throw new ValidationException("Not a valid UUID: ${uuid}");
      }
      query = FieldModel._UPDATE_FIELD;
    } else {
      uuid = generateUuid();
      query = FieldModel._INSERT_FIELD;
    }

    query = query.replaceAll(_AModel._UUID_REPLACEMENT_STRING, uuid.replaceAll("-", ""));

    if(!data.containsKey("title")) {
      throw new ValidationException("\"title\" property is required");
    }
    if(isNullOrWhitespace(data["title"])) {
      throw new ValidationException("\"title\" must have a value");
    }
    if(!data.containsKey("type")) {
      throw new ValidationException("\"type\" property is required");
    }
    if(isNullOrWhitespace(data["type"])) {
      throw new ValidationException("\"type\" must have a value");
    }

    mysql.Query q = await pool.prepare(query);
    try {
      mysql.Results r = await q.execute([data["title"],data["type"],data["pattern"]]);
    } finally {
      q.close();
    }
  }

//  Future write(String name, String title, String type, String pattern) {
//    return _write(this.createFieldMap(name, title, type, pattern));
//  }


}