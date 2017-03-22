import 'dart:async';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:connection_pool/connection_pool.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'mongo_db_connection_pool.dart';
import 'a_mongo_id_data_source.dart';

class MongoDatabase {
  static final Logger _log = new Logger('_MongoDatabase');
  static MongoDbConnectionPool _pool;

  static const String _settingsCollection = "settings";
  static const String _itemsCollection = "items";
  static const String _fieldsCollection = "fields";
  static const String _itemTypesCollection = "itemTypes";
  static const String _historyCollection = "itemCopyHistory";
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

  Map createRedirectMap(String oldId, String newId) {
    return {"id": oldId, redirectEntryName: newId};
  }

  Future<DbCollection> getCollectionsCollection() async {
    _checkConnection();

    final dynamic output = await con.conn.collection(_collectionsCollection);
    return output;
  }

  Future<DbCollection> getFieldsCollection() async {
    _checkConnection();

    final dynamic output = await con.conn.collection(_fieldsCollection);
    return output;
  }

  Future<DbCollection> getItemCopyHistoryCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_historyCollection);
    await con.conn.createIndex(_historyCollection,
        keys: {"itemId": 1, "copy": 1}, name: "ItemIdIndex");
    return output;
  }

  Future<DbCollection> getItemsCollection() async {
    _checkConnection();
    dynamic output = await con.conn.collection(_itemsCollection);
    await con.conn.createIndex(_itemsCollection,
        keys: {r"$**": "text"}, name: "TextIndex");
    await con.conn.createIndex(_itemsCollection,
        keys: {idField: 1, "copies.copy": 1}, unique: true, name: "CopyIndex");
    await con.conn.createIndex(_itemsCollection,
        key: "copies.uniqueId",
        unique: true,
        sparse: true,
        name: "UniqueIdIndex");
    return output;
  }

  Future<DbCollection> getItemTypesCollection() async {
    _checkConnection();

    dynamic output = con.conn.collection(_itemTypesCollection);
    return output;
  }

  Future<DbCollection> getSettingsCollection() async {
    _checkConnection();

    dynamic output = con.conn.collection(_settingsCollection);
    return output;
  }

  Future<DbCollection> getSetupCollection() async {
    dynamic output = con.conn.collection("setup");
    return output;
  }

  Future<DbCollection> getTransactionsCollection() async {
    dynamic output = con.conn.collection("transactions");
    return output;
  }

  Future<DbCollection> getUsersCollection() async {
    _checkConnection();
    DbCollection output = await con.conn.collection(_usersCollection);
    await con.conn.createIndex(_usersCollection,
        keys: {"id": "text", "name": "text", "idNumber": "text"},
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
    DbCollection transactions = await getTransactionsCollection();
    transactions.findOne({"state": "initial"});
  }

  void _checkConnection() {
    if (released) throw new Exception("Connection has already been released");
  }

  static Future<MongoDatabase> getConnection() async {
    if (_pool == null) {
      _pool =
          new MongoDbConnectionPool(model.settings.mongoConnectionString, 3);
    }

    ManagedConnection con = await _pool.getConnection();
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
