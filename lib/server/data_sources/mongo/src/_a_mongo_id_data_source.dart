part of data_sources.mongo;

abstract class _AMongoIdDataSource<T extends AIdData>
    extends _AMongoObjectDataSource<T> with AIdNameBasedDataSource<T> {

  Future delete(String id) => _deleteFromDb(where.eq(ID_FIELD, id));

  Future<bool> exists(String id) => _exists(where.eq(ID_FIELD, id));

  Future<List<T>> search(String query);

  Future<List<T>> getAll({String sortField: ID_FIELD}) =>
      _getFromDb(where.sortBy(sortField));

  Future<List<IdNamePair>> getAllIdsAndNames(
      {String sortField: ID_FIELD}) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      DbCollection collection = await _getCollection(con);

      List results =
          await collection.find(where.sortBy(sortField)).toList();

      List<IdNamePair> output = new List<IdNamePair>();

      for (var result in results) {
        output.add(new IdNamePair.from(result[ID_FIELD], result["name"]));
      }

      return output;
    } finally {
      con.release();
    }
  }

  Future<Option<T>> getById(String id) =>
      _getForOneFromDb(where.eq(ID_FIELD, id));

  Future<String> write(T object, [String id = null]) async {
    if (!tools.isNullOrWhitespace(id)) {
      await _updateToDb(where.eq(ID_FIELD, id), object);
    } else {
      await _insertIntoDb(object);
    }
    dynamic tmp = object;
    return tmp.getId;
  }
}
