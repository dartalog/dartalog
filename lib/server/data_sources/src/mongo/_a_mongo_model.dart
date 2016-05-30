part of data_sources;

abstract class _AMongoModel<T> {
  Map _createMap(T object) {
    Map data = new Map();
    _updateMap(object, data);
    return data;
  }

  T _createObject(Map data);

  Future _deleteFromDb(dynamic selector) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);
      await collection.remove(selector);
    } finally {
      con.release();
    }
  }


  Future<mongo.DbCollection> _getCollection(_MongoDatabase con);

  Future<T> _getForOneFromDb(dynamic selector) async {
    List results = await _getFromDb(selector);
    if (results.length == 0) {
      return null;
    }
    return results.first;
  }

  Future<List<T>> _getFromDb(dynamic selector) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);

      List results = await collection.find(selector).toList();

      List<T> output = new List<T>();
      for (var result in results) {
        output.add(_createObject(result));
      }
      return output;
    } finally {
      con.release();
    }
  }

  _updateMap(T object, Map data);

  Future _updateToDb(dynamic selector, T item) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);
      Map data = await collection.findOne(selector);
      if(data==null)
        throw new InvalidInputException("Object to update not found");
      _updateMap(item, data);
      await collection.save(data);
    } finally {
      con.release();
    }
  }

  Future _insertIntoDb(T item) async {
    _MongoDatabase con = await _MongoDatabase.getConnection();
    try {
      mongo.DbCollection collection = await _getCollection(con);

      Map data = _createMap(item);
      await collection.insert(data);
    } finally {
      con.release();
    }
  }

}

