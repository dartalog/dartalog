part of data_sources;

abstract class _AMongoIdDataSource<T extends AIdData>
    extends _AMongoDataSource<T> {
  static const String ID_FIELD = "id";

  Future delete(String id) => _deleteFromDb(mongo.where.eq(ID_FIELD, id));

  Future<bool> exists(String id) => _exists(mongo.where.eq(ID_FIELD, id));

  Future<List<T>> getAll({String sortField: ID_FIELD}) =>
      _getFromDb(mongo.where.sortBy(sortField));

  Future<List<IdNamePair>> getAllIdsAndNames(
      {String sortField: ID_FIELD}) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);

      List results =
          await collection.find(mongo.where.sortBy(sortField)).toList();

      List<IdNamePair> output = new List<IdNamePair>();

      for (var result in results) {
        output.add(new IdNamePair.from(result[ID_FIELD], result["name"]));
      }

      return output;
    } finally {
      con.release();
    }
  }

  Future<T> getById(String id) =>
      _getForOneFromDb(mongo.where.eq(ID_FIELD, id));

  Future<String> write(T object, [String id = null]) async {
    if (!tools.isNullOrWhitespace(id)) {
      await _updateToDb(mongo.where.eq(ID_FIELD, id), object);
    } else {
      await _insertIntoDb(object);
    }
    dynamic tmp = object;
    return tmp.getId;
  }
}
