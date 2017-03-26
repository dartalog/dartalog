import 'dart:async';

import 'package:connection_pool/connection_pool.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'a_mongo_id_data_source.dart';
import 'mongo_db_connection_pool.dart';
import 'constants.dart';

class MongoDatabase {
  static final Logger _log = new Logger('_MongoDatabase');
  static MongoDbConnectionPool _pool;

  static const String _settingsCollection = "settings";
  static const String _itemsCollection = "items";
  static const String _fieldsCollection = "fields";
  static const String _itemTypesCollection = "itemTypes";
  static const String _collectionsCollection = "collections";
  static const String _usersCollection = "users";

  static String redirectEntryName = "redirect";
  ManagedConnection<Db> con;

  bool released = false;

  MongoDatabase(this.con);

  void checkForRedirectMap(Map data) {
    if (data.containsKey(redirectEntryName)) {
      throw new Exception("Not inplemented"); //TODO: Implement!
      //throw new api.RedirectingException(data["id"], data[REDIRECT_ENTRY_NAME]);
    }
  }

  Map createRedirectMap(String oldUuid, String newUuid) {
    return {"uuid": oldUuid, redirectEntryName: newUuid};
  }

  Future<DbCollection> getUuidCollection(String collectionName) async {
    _checkConnection();
    await con.conn.createIndex(collectionName,
        keys: {uuidField: 1}, name: "UuidIndex", unique: true);
    return con.conn.collection(collectionName);
  }

  Future<DbCollection> getHumanReadableCollection(String collectionName) async {
    final DbCollection output = await getUuidCollection(collectionName);
    await con.conn.createIndex(collectionName,
        keys: {readableIdField: 1}, name: "ReadableIdIndex", unique: true);
    return output;
  }


  Future<DbCollection> getCollectionsCollection() async {
    return await getHumanReadableCollection(_collectionsCollection);
  }

  Future<DbCollection> getFieldsCollection() async {
    return await getHumanReadableCollection(_fieldsCollection);
  }

  Future<DbCollection> getItemsCollection() async {
    final DbCollection output = await getHumanReadableCollection(_itemsCollection);
    await con.conn.createIndex(_itemsCollection,
        keys: {r"$**": "text"}, name: "TextIndex");
    await con.conn.createIndex(_itemsCollection,
        key: itemCopyUniqueIdPath,
        unique: true,
        sparse: true,
        name: "UniqueIdIndex");
    await con.conn.createIndex(_itemsCollection,
        key: itemCopyUuidPath,
        unique: true,
        sparse: true,
        name: "ItemCopyUuidIndex");
    return output;
  }

  Future<DbCollection> getItemTypesCollection() async {
    return await getHumanReadableCollection(_itemTypesCollection);
  }

  Future<DbCollection> getSettingsCollection() async {
    _checkConnection();
    final DbCollection output = con.conn.collection(_settingsCollection);
    return output;
  }

  Future<DbCollection> getTransactionsCollection() async {
    _checkConnection();
    final DbCollection output = con.conn.collection("transactions");
    return output;
  }

  Future<DbCollection> getUsersCollection() async {
    final DbCollection output = await getUuidCollection(_usersCollection);
    await con.conn.createIndex(_usersCollection,
        keys: {"id": "text", "name": "text"},
        name: "TextIndex");
    return output;
  }

  void release({bool dispose: false}) {
    if (released) return;
    if (dispose) {
      _pool.releaseConnection(con, markAsInvalid: true);
    } else {
      _pool.releaseConnection(con);
    }
    con = null;
    released = true;
  }

  Future<Null> startTransaction() async {
    final DbCollection transactions = await getTransactionsCollection();
    await transactions.findOne({"state": "initial"});
  }

  void _checkConnection() {
    if (released) throw new Exception("Connection has already been released");
  }

  static Future<Null> testConnectionString(String connectionString) async {
    final MongoDbConnectionPool pool = new MongoDbConnectionPool(connectionString, 3);
    final ManagedConnection<Db> con =  await pool.getConnection();
    pool.releaseConnection(con);
    await pool.closeConnections();
  }

  static Future<Null> closeAllConnections() async {
    final MongoDbConnectionPool pool = _pool;
    _pool = null;
    try {
      if (pool != null) {
        await pool.closeConnections();
      }
    } catch (e,st) {
      _log.warning("changeConnectionString", e, st);
    }
  }

  static Future<MongoDatabase> getConnection() async {
    if (_pool == null) {
      _pool =
          new MongoDbConnectionPool(model.settings.mongoConnectionString, 3);
    }

    ManagedConnection<Db> con = await _pool.getConnection();
    Db db = con.conn;

    int i = 0;
    while (db == null || db.state != State.OPEN) {
      if (i > 5) {
        throw new Exception(
            "Too many attempts to fetch a connection from the pool");
      }
      if (con != null) {
        _log.info(
            "Mongo database connection has issue, returning to pool and re-fetching");
        _pool.releaseConnection(con, markAsInvalid: true);
      }
      con = await _pool.getConnection();
      db = con.conn;
      i++;
    }

    return new MongoDatabase(con);
  }
}
