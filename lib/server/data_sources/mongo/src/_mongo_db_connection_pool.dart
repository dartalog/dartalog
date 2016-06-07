part of data_sources.mongo;

/**
 * A MongoDB connection pool
 *
 */
class _MongoDbConnectionPool extends ConnectionPool<Db> {
  static final Logger _log = new Logger('_MongoDbConnectionPool');

  String uri;

  _MongoDbConnectionPool(String this.uri, int poolSize) : super(poolSize);

  @override
  void closeConnection(Db conn) {
    _log.info("Closing mongo connection");
    conn.close();
  }

  @override
  Future<Db> openNewConnection() {
    _log.info("Opening mongo connection");
    var conn = new Db(uri);
    return conn.open().then((_) => conn);
  }
}
