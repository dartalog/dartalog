import 'dart:async';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:connection_pool/connection_pool.dart';
import 'mongo_database.dart';

class MongoDbConnectionPool extends ConnectionPool<Db> {
  static final Logger _log = new Logger('_MongoDbConnectionPool');

  final String uri;


  MongoDbConnectionPool(this.uri, [int poolSize= 5]) : super(poolSize);

  @override
  void closeConnection(Db conn) {
      _log.info("Closing mongo connection");
      conn.close();
  }

  @override
  Future<Db> openNewConnection() async{
    _log.info("Opening mongo connection");
    final Db conn = new Db(uri);
    if(await conn.open())
      return conn;
    else
      throw new Exception("Could not open connection");
  }


  Future<dynamic> databaseWrapper(
      Future<dynamic> statement(MongoDatabase db),
      {int retries: 5}) async {
    // The number of retries should be at least as much as the number of connections in the connection pool.
    // Otherwise it might run out of retries before invalidating every potentially disconnected connection in the pool.
    for (int i = 0; i < retries; i++) {
      bool closeConnection = false;
      final ManagedConnection<Db> conn = await _getConnection();

      try {
        return await statement(new MongoDatabase(conn.conn));
      } on ConnectionException catch (e, st) {
        if (i >= retries) {
          _log.severe(
              "ConnectionException while operating on mongo database", e, st);
          rethrow;
        } else {
          _log.warning(
              "ConnectionException while operating on mongo database, retrying",
              e,
              st);
        }
        closeConnection = true;
      } finally {
        this.releaseConnection(conn, markAsInvalid: closeConnection);
      }
    }
  }



  Future<ManagedConnection<Db>> _getConnection() async {
    ManagedConnection<Db> con = await this.getConnection();

    // Theoretically this should be able to catch closed connections, but it can't catch connections that were closed by the server without notifying the client, like when the server restarts.
    int i = 0;
    while (con?.conn == null || con.conn.state != State.OPEN) {
      if (i > 5) {
        throw new Exception(
            "Too many attempts to fetch a connection from the pool");
      }
      if (con != null) {
        _log.info(
            "Mongo database connection has issue, returning to pool and re-fetching");
        this.releaseConnection(con, markAsInvalid: true);
      }
      con = await this.getConnection();
      i++;
    }

    return con;
  }

  static Future<Null> testConnectionString(String connectionString) async {
    final MongoDbConnectionPool pool =
    new MongoDbConnectionPool(connectionString, 1);
    final ManagedConnection<Db> con = await pool.getConnection();
    pool.releaseConnection(con);
    await pool.closeConnections();
  }

}
