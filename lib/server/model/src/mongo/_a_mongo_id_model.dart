part of model;

abstract class _AMongoIdModel<T> extends _AMongoModel<T> {
  Future<List<T>> getAll() async {
    _log.info("Getting all from collection");
    return await _getFromDb(null);
  }

  Future delete(String id) async {
    await _deleteFromDb(mongo.where.eq("id", id));
  }


  Future<List<api.IdNamePair>> getAllIdsAndNames() async {
    _log.info("Getting all IDs and names ");
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);

      List results = await collection.find().toList();

      List<api.IdNamePair> output = new List<api.IdNamePair>();

      for (var result in results) {
        output.add(new api.IdNamePair.from(result["id"], result["name"]));
      }

      return output;
    } finally {
      con.release();
    }
  }

  Future<T> getById(String id) async {
    return await _getForOneFromDb(mongo.where.eq("id", id));
  }

  Future write(T object, [String id = null]) async {
    if (!tools.isNullOrWhitespace(id)) {
      await _updateToDb(mongo.where.eq("id", id), object);
    } else {
      await _insertIntoDb(object);
    }
  }

}
