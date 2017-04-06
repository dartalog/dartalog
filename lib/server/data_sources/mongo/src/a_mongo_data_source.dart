import 'dart:async';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';
import 'mongo_database.dart';
import 'package:meta/meta.dart';

export 'mongo_database.dart';

abstract class AMongoDataSource {
  static final Logger _log = new Logger('AMongoDataSource');

  int getOffset(int page, int perPage) => page * perPage;

  Future<dynamic> _connectionWrapper(
      Future<dynamic> statement(MongoDatabase db),
      {int retries: 5}) async {
    // The number of retries should be at least as much as the number of connections in the connection pool.
    // Otherwise it might run out of retries before invalidating every potentially disconnected connection in the pool.
    for (int i = 0; i < retries; i++) {
      bool closeConnection = false;
      final MongoDatabase con = await MongoDatabase.getConnection();

      try {
        return await statement(con);
      } on ConnectionException catch (e, st) {
        if(i>=retries) {
          _log.severe(
              "ConnectionException while operating on mongo database",
              e,
              st);
          rethrow;
        } else {
          _log.warning(
              "ConnectionException while operating on mongo database, retrying",
              e,
              st);
        }
        closeConnection = true;
      } finally {
        con.release(dispose: closeConnection);
      }
    }
  }

  @protected
  Future<dynamic> collectionWrapper(
          Future<dynamic> statement(DbCollection c)) =>
      _connectionWrapper((MongoDatabase con) async =>
          await statement(await getCollection(con)));

  @protected
  Future<Null> deleteFromDb(dynamic selector) async {
    await collectionWrapper((DbCollection collection) async {
      await collection.remove(selector);
    });
  }

  @protected
  Future<DbCollection> getCollection(MongoDatabase con);

  @protected
  Future<dynamic> genericUpdate(dynamic selector, dynamic document,
      {bool multiUpdate: false}) async {
    return await collectionWrapper((DbCollection collection) async {
      return await collection.update(selector, document,
          multiUpdate: multiUpdate);
    });
  }

  @protected
  Future<dynamic> aggregate(List<dynamic> pipeline) async {
    return await collectionWrapper((DbCollection collection) async {
      return await collection.aggregate(pipeline);
    });
  }

  @protected
  Future<bool> exists(dynamic selector) async {
    return await collectionWrapper((DbCollection collection) async {
      final int count = await collection.count(selector);
      return count > 0;
    });
  }

  @protected
  Future<Option<dynamic>> genericFindOne(SelectorBuilder selector) async {
    final List<dynamic> output = await genericFind(selector.limit(1));
    if (output.length == 0) return new None<dynamic>();
    return new Some<dynamic>(output[0]);
  }

  @protected
  Future<List<dynamic>> genericFind(SelectorBuilder selector) async {
    return await collectionWrapper((DbCollection collection) async {
      final Stream<dynamic> str = collection.find(selector);
      final List<dynamic> output = await str.toList();
      return output;
    });
  }

  Future<Stream<dynamic>> genericFindStream(SelectorBuilder selector) async {
    return await collectionWrapper((DbCollection collection) async {
      return collection.find(selector);
    });
  }

  @protected
  Future<int> genericCount(SelectorBuilder selector) async {
    return await collectionWrapper((DbCollection collection) async {
      return collection.count(selector);
    });
  }
}
