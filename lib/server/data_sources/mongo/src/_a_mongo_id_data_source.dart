part of data_sources.mongo;

abstract class _AMongoIdDataSource<T extends AIdData>
    extends _AMongoObjectDataSource<T> with AIdNameBasedDataSource<T> {

  Future delete(String id) => _deleteFromDb(where.eq(ID_FIELD, id));

  Future<bool> exists(String id) => _exists(where.eq(ID_FIELD, id));

  Future<IdNameList<T>> getAll({String sortField: ID_FIELD}) =>
      _getIdNameListFromDb(where.sortBy(sortField));

  Future<PaginatedIdNameData<T>> getPaginated({String sortField: ID_FIELD, int offset: 0, int limit: PAGINATED_DATA_LIMIT}) =>
      _getPaginatedIdNameListFromDb(where.sortBy(sortField), offset: offset, limit: limit);

  Future<IdNameList<IdNamePair>> getAllIdsAndNames(
      {String sortField: ID_FIELD}) => getIdsAndNames(sortField: sortField);

  Future<IdNameList<IdNamePair>> getIdsAndNames(
      {SelectorBuilder selector, String sortField: ID_FIELD}) async {
    return await _collectionWrapper((DbCollection collection) async {

      if(selector==null)
        selector = where;

      selector.sortBy(sortField);

      List results = await collection.find(selector).toList();

      IdNameList<IdNamePair> output = new IdNameList<IdNamePair>();

      for (var result in results) {
        output.add(new IdNamePair.from(result[ID_FIELD], result["name"]));
      }

      return output;
    });
  }

  Future<PaginatedIdNameData<IdNamePair>> getPaginatedIdsAndNames(
      {String sortField: ID_FIELD, int offset: 0, int limit: 10}) async {
    return await _collectionWrapper((DbCollection collection) async {
      int count = await collection.count();
      List results = await collection.find(where.sortBy(sortField).limit(limit).skip(offset)).toList();

      PaginatedIdNameData<IdNamePair> output = new PaginatedIdNameData<IdNamePair>();
      output.startIndex = offset;
      output.limit = limit;
      output.totalCount = count;

      for (var result in results) {
        output.data.add(new IdNamePair.from(result[ID_FIELD], result["name"]));
      }

      return output;
    });
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

  Future<PaginatedIdNameData<T>> _getPaginatedIdNameListFromDb(dynamic selector, {int offset: 0, int limit: PAGINATED_DATA_LIMIT}) async =>
      new PaginatedIdNameData<T>.copyPaginatedData(await _getPaginatedFromDb(selector, offset: offset, limit:limit));

  Future<IdNameList<T>> _getIdNameListFromDb(dynamic selector) async =>
    new IdNameList<T>.copy(await _getFromDb(selector));

  @override
  Future<IdNameList<T>> search(String query, {SelectorBuilder selector, String sortBy}) async {
    List data = await _search(query, selector: selector, sortBy: sortBy);
    return new IdNameList.copy(data);
  }

}
