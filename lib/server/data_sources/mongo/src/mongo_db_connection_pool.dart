import 'dart:async';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:connection_pool/connection_pool.dart';

/// A MongoDB connection pool
class MongoDbConnectionPool extends ConnectionPool<Db> {
  static final Logger _log = new Logger('_MongoDbConnectionPool');

  String uri;

  MongoDbConnectionPool(this.uri, int poolSize) : super(poolSize);

  @override
  void closeConnection(Db conn) {
    _log.info("Closing mongo connection");
    conn.close();
  }

  @override
  Future<Db> openNewConnection() {
    _log.info("Opening mongo connection");
    final Db conn = new Db(uri);
    return conn.open().then((_) => conn);
  }
}
