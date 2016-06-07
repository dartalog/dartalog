part of data_sources.mongo;

abstract class _AMongoDataSource<T> {
  Map _createMap(T object) {
    Map data = new Map();
    _updateMap(object, data);
    return data;
  }

  T _createObject(Map data);

  Future<dynamic> _connectionWrapper(Future statement(_MongoDatabase)) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      return await statement(con);
    } finally {
      con.release();
    }
  }

  Future<dynamic> _collectionWrapper(Future statement(DbCollection)) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      return await statement(await _getCollection(con));
    } finally {
      con.release();
    }
  }


  Future _deleteFromDb(dynamic selector) async {
    return await _connectionWrapper((_MongoDatabase con) async {
      DbCollection collection = await _getCollection(con);
      await collection.remove(selector);
    });
  }

  Future<DbCollection> _getCollection(_MongoDatabase con);

  Future<Option<T>> _getForOneFromDb(dynamic selector) async {
    List results = await _getFromDb(selector);
    if (results.length == 0) {
      return new None();
    }
    return new Some(results.first);
  }

  Future<dynamic> _genericUpdate(dynamic selector, dynamic document, {bool multiUpdate: false}) async {
    return await _collectionWrapper((DbCollection collection) async {
      return await collection.update(selector, document, multiUpdate: multiUpdate);
    });
  }

  Future<dynamic> _aggregate(List<dynamic> pipeline) async {
    return await _collectionWrapper((DbCollection collection) async {
      return await collection.aggregate(pipeline);
    });
  }

  Future<bool> _exists(dynamic selector) async {
    return await _collectionWrapper((DbCollection collection) async {

      int count = await collection.count(selector);

      return count>0;
    });
  }


  Future<List<T>> _getFromDb(dynamic selector) async {
    List results = await _genericFind(selector);
    List<T> output = new List<T>();
    for (var result in results) {
      output.add(_createObject(result));
    }
    return output;
  }


  Future<dynamic> _genericFind(dynamic selector) async {
    return await _collectionWrapper((DbCollection collection) async {
      return await collection.find(selector).toList();
    });
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

