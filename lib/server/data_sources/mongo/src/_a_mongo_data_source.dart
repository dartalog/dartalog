part of data_sources.mongo;

abstract class _AMongoDataSource {
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

  Future<Option<dynamic>> _genericFindOne(SelectorBuilder selector) async {
    selector = selector.limit(1);
    List output = await _genericFind(selector);
    if(output.length==0)
      return new None();
    return new Some(output[0]);
  }

  Future<List> _genericFind(SelectorBuilder selector) async {
    return await _collectionWrapper((DbCollection collection) async {
      Stream str = collection.find(selector);
      List output = await str.toList();
      return output;
    });
  }

}

