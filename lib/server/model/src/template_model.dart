part of model;

class TemplateModel extends _AModel {
  static final Logger _log = new Logger('TemplateModel');

  //ADatabase _db;
  //ANoSqlDatabase get _nsdb => this._db;
  //mongo.Db _db;

  TemplateModel();

  static const String _GET_ALL_TEMPLATES = "SELECT HEX(uuid) uuid, name FROM templates ORDER BY name;";
  static const String _GET_TEMPLATE_BY_UUID = "SELECT HEX(uuid) uuid, name FROM templates WHERE uuid = 0x${_AModel._UUID_REPLACEMENT_STRING}";
  static const String _GET_TEMPLATE_BY_NAME = "SELECT HEX(uuid) uuid, name FROM templates WHERE name = ?";
  static const String _UPDATE_TEMPLATE = "UPDATE templates SET name = ? WHERE uuid = 0x${_AModel._UUID_REPLACEMENT_STRING}";
  static const String _INSERT_TEMPLATE = "INSERT INTO templates (uuid, name) VALUES (0x${_AModel._UUID_REPLACEMENT_STRING}, ?);";

  static const String _GET_ALL_TEMPLATES_WITH_FIELDS =
  """SELECT HEX(t.uuid) uuid, t.name, HEX(field_uuid) field_uuid, f.name field_name
          FROM templates t
          LEFT JOIN template_fields tf ON tf.template_uuid = t.uuid
          LEFT JOIN fields f ON tf.field_uuid = f.uuid
          ORDER BY t.uuid, f.uuid;""";

  static const String _GET_ALL_TEMPLATE_FIELDS = "SELECT HEX(template_uuid) uuid FROM template_fields WHERE template_uuid = 0x${_AModel._UUID_REPLACEMENT_STRING}";

  Future<List<Template>> getAll() async {
    _log.info("Getting all templates");

    mysql.ConnectionPool pool = Model.getConnectionPool();

    Stream str = await pool.query(TemplateModel._GET_ALL_TEMPLATES_WITH_FIELDS);
    List results = await str.toList();

    List<Template> output = new List<Template>();
    for (dynamic result in results) {
      Template tmplt;
      if (tmplt == null || tmplt.uuid != formatUuid(result.uuid)) {
        tmplt = new Template.fromData(result);
        output.add(tmplt);
      }
      if (result.field_uuid != null) {
        tmplt.fields.add(formatUuid(result.field_uuid));
      }
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


  Future write(Map<String,Object> data, [String uuid = null]) {
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
      query = FieldsModel._UPDATE_FIELD + uuid.replaceAll("-", "");
    } else {
      query = FieldsModel._INSERT_FIELD;
    }

//    if(!data.containsKey("name")) {
//      throw new ValidationException("\"name\" property is required");
//    }
//    if(isNullOrWhitespace(data["name"])) {
//      throw new ValidationException("\"name\" must have a value");
//    }
    if(!data.containsKey("title")) {
      throw new ValidationException("\"title\" property is required");
    }
    if(isNullOrWhitespace(data["title"])) {
      throw new ValidationException("\"title\" must have a value");
    }

    return pool.prepare(query).then((mysql.Query q) {
      return q.execute([data["name"],data["title"],data["type"],data["pattern"]]).then((mysql.Results r) {

      }).whenComplete(() {
        q.close();
      });
    });
  }

//  Future write(String name, String title, String type, String pattern) {
//    return _write(this.createFieldMap(name, title, type, pattern));
//  }

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