part of model;

/**
 * A MongoDB connection pool
 *
 */
class _MongoDbConnectionPool extends ConnectionPool<mongo.Db> {
  static final Logger _log = new Logger('_MongoDbConnectionPool');

  String uri;

  _MongoDbConnectionPool(String this.uri, int poolSize) : super(poolSize);

  @override
  void closeConnection(mongo.Db conn) {
    _log.info("Closing mongo connection");
    conn.close();
  }

  @override
  Future<mongo.Db> openNewConnection() {
    _log.info("Opening mongo connection");
    var conn = new mongo.Db(uri);
    return conn.open().then((_) => conn);
  }
}
