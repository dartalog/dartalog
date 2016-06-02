part of data_sources;

abstract class _AMongoIdModel<T extends AIdData> extends _AMongoModel<T> {
  Future<List<T>> getAll({String sortField: "id"}) => _getFromDb(mongo.where.sortBy(sortField));

  Future delete(String id) => _deleteFromDb(mongo.where.eq("id", id));


  Future<List<IdNamePair>> getAllIdsAndNames({String sortField: 'id'}) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);

      List results = await collection.find(mongo.where.sortBy(sortField)).toList();

      List<IdNamePair> output = new List<IdNamePair>();

      for (var result in results) {
        output.add(new IdNamePair.from(result["id"], result["name"]));
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
    return tmp.getId;
  }

}
