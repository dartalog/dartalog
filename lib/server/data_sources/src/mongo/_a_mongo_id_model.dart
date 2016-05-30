part of data_sources;

abstract class _AMongoIdModel<T extends api.AIdData> extends _AMongoModel<T> {
  Future<List<T>> getAll() => _getFromDb(null);

  Future delete(String id) => _deleteFromDb(mongo.where.eq("id", id));


  Future<List<api.IdNamePairResponse>> getAllIdsAndNames() async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);

      List results = await collection.find().toList();

      List<api.IdNamePairResponse> output = new List<api.IdNamePairResponse>();

      for (var result in results) {
        output.add(new api.IdNamePairResponse.from(result["id"], result["name"]));
      }

      return output;
    } finally {
      con.release();
    }
  }

  Future<T> getById(String id) => _getForOneFromDb(mongo.where.eq("id", id));

  Future<String> write(T object, [String id = null]) async {
    if (!tools.isNullOrWhitespace(id)) {
      await _updateToDb(mongo.where.eq("id", id), object);
    } else {
      await _insertIntoDb(object);
    }
    dynamic tmp = object;
    return tmp.id;
  }

}
