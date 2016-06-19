part of data_sources.mongo;

abstract class _AMongoObjectDataSource<T> extends _AMongoDataSource {
  Map _createMap(T object) {
    Map data = new Map();
    _updateMap(object, data);
    return data;
  }

  T _createObject(Map data);


  Future<List<T>> search(String query) async {
    return await _search(query);
  }
  Future<List<T>> _search(String query, {SelectorBuilder selector}) async {
    if(selector==null)
      selector = where;

    selector.map[_TEXT_COMMAND] = {_SEARCH_COMMAND: query};
    return await _getFromDb(selector);
  }

  Future<PaginatedData<T>> searchPaginated(String query, {int offset: 0, int limit: PAGINATED_DATA_LIMIT}) async {
    SelectorBuilder selector = where;
    selector.map[_TEXT_COMMAND] = {_SEARCH_COMMAND: query};
    return await _getPaginatedFromDb(selector, offset: offset, limit: limit);
  }

  Future<DbCollection> _getCollection(_MongoDatabase con);

  Future<Option<T>> _getForOneFromDb(SelectorBuilder selector) async {
    selector = selector.limit(1);
    List results = await _getFromDb(selector);
    if (results.length == 0) {
      return new None();
    }
    return new Some(results.first);
  }

  Future<PaginatedData<T>> _getPaginatedFromDb(SelectorBuilder selector, {int offset: 0, int limit: PAGINATED_DATA_LIMIT}) async {
    PaginatedData<T> output = new PaginatedData<T>();
    output.totalCount = await _genericCount(selector);
    output.limit = limit;
    output.startIndex = offset;

    if(selector==null)
      selector == where;
      selector.limit(limit).skip(offset);

    output.data.addAll(await _getFromDb(selector));
    return output;
  }

  Future<List<T>> _getFromDb(dynamic selector) async {
    List results = await _genericFind(selector);
    List<T> output = new List<T>();
    for (var result in results) {
      output.add(_createObject(result));
    }
    return output;
  }

  _updateMap(T object, Map data);

  Future _updateToDb(dynamic selector, T item) async {
    return await _collectionWrapper((DbCollection collection) async {
      Map data = await collection.findOne(selector);
      if(data==null)
        throw new InvalidInputException("Object to update not found");
      _updateMap(item, data);
      await collection.save(data);
    });
  }

  Future _insertIntoDb(T item) async {
    return await _collectionWrapper((DbCollection collection) async {

      Map data = _createMap(item);
      await collection.insert(data);
    });
  }

}

