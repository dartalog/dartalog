part of data_sources;

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

  Future _deleteFromDb(dynamic selector) async {
    return await _connectionWrapper((_MongoDatabase con) async {
      mongo.DbCollection collection = await _getCollection(con);
      await collection.remove(selector);
    });
  }


  Future<mongo.DbCollection> _getCollection(_MongoDatabase con);

  Future<T> _getForOneFromDb(dynamic selector) async {
    List results = await _getFromDb(selector);
    if (results.length == 0) {
      return null;
    }
    return results.first;
  }

  Future<bool> _exists(dynamic selector) async {
    return await _connectionWrapper((_MongoDatabase con) async {
      mongo.DbCollection collection = await _getCollection(con);

      int count = await collection.count(selector);

      return count>0;
    });
  }

  Future<List<T>> _getFromDb(dynamic selector) async {
    return await _connectionWrapper((_MongoDatabase con) async {
      mongo.DbCollection collection = await _getCollection(con);

      List results = await collection.find(selector).toList();

      List<T> output = new List<T>();
      for (var result in results) {
        output.add(_createObject(result));
      }
      return output;
    });
  }

  _updateMap(T object, Map data);

  Future _updateToDb(dynamic selector, T item) async {
    return await _connectionWrapper((_MongoDatabase con) async {
      mongo.DbCollection collection = await _getCollection(con);
      Map data = await collection.findOne(selector);
      if(data==null)
        throw new InvalidInputException("Object to update not found");
      _updateMap(item, data);
      await collection.save(data);
    });
  }

  Future _insertIntoDb(T item) async {
    return await _connectionWrapper((_MongoDatabase con) async {
      mongo.DbCollection collection = await _getCollection(con);

      Map data = _createMap(item);
      await collection.insert(data);
    });
  }

}

