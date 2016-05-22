part of model;

class _MongoFieldModel extends AFieldModel {
  static final Logger _log = new Logger('_MongoFieldModel');

  Future<Map<String,String>> getAllIDsAndNames() async {
    _log.info("Getting all field IDs and names ");
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getFieldsCollection();

    List results = await collection.find().toList();

    Map<String,String> output = new Map<String,String>();
    for (var result in results) {
      output[result["id"]] = result["name"];
    }

    con.release();
    return output;
  }

  Future<List<api.Field>> getAll() async {
    _log.info("Getting all fields");
    return await _getFromDb(null);
  }

  Future<api.Field> get(String id) async {
    _log.info("Getting specific field by id: ${id}");


    dynamic criteria;
    criteria = mongo.where.eq("id", id);

    List results = await _getFromDb(criteria);

    if(results.length==0) {
      return null;
    }

    return results.first;
  }


  Future<List<api.Field>> getAllForIDs(List<String> ids) async {
    _log.info("Getting all fields for IDs");

    if(ids==null)
      return new List<api.Field>();

    mongo.SelectorBuilder query = null;

    for(String id in ids) {
      mongo.SelectorBuilder sb = mongo.where.eq("id", id);
      if(query==null) {
        query = sb;
      } else {
        query.or(sb);
      }
    }

    List results = await _getFromDb(query);

    return results;
  }

  Future<List<api.Field>> _getFromDb(dynamic selector) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getFieldsCollection();

    List results = await collection.find(selector).toList();

    List<api.Field> output = new List<api.Field>();
    for (var result in results) {
      //mongo.ObjectId id = result["_id"];
      //String str_id = id.toJson();
      output.add(_createField(result));
    }
    con.release();
    return output;

  }

  Future write(api.Field field, [String id = null]) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    mongo.DbCollection collection = await con.getFieldsCollection();

    Map data;
    if(!tools.isNullOrWhitespace(id)) {
      data = await collection.findOne({"id": id});
    }
    if(data==null) {
      data = _createMap(field);
      dynamic result = await collection.insert(data);
      return;
    }

    _updateMap(field, data);
    await collection.save(data);
    con.release();
    return;
  }

  api.Field _createField(Map data) {
    api.Field output = new api.Field();
    output.id = data["id"];
    output.name = data["name"];
    output.type = data["type"];
    output.format = data["format"];
    return output;
  }

  Map _createMap(api.Field field) {
    Map data = new Map();
    _updateMap(field,data);
    return data;
  }

  void _updateMap(api.Field field, Map data) {
    data["id"] = field.id;
    data["name"] = field.name;
    data["type"] = field.type;
    data["format"] = field.format;
  }
}