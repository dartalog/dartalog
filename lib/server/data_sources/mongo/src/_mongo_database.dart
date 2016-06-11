part of data_sources.mongo;

class _MongoDatabase {
  static final Logger _log = new Logger('_MongoDatabase');
  static _MongoDbConnectionPool _pool;

  static const String _SETTINGS_MONGO_COLLECTION = "settings";
  static const String _ITEMS_MONGO_COLLECTION = "items";
  static const String _FIELDS_MONGO_COLLECTION = "fields";
  static const String _ITEM_TYPES_MONGO_COLLECTION = "itemTypes";
  static const String _ITEM_COPY_HISTORY_MONGO_COLLECTION = "itemCopyHistory";
  static const String _COLLECTIONS_MONGO_COLLECTION = "collections";
  static const String _USERS_MONGO_COLLECTION = "users";

  static String REDIRECT_ENTRY_NAME = "redirect";
  ManagedConnection<Db> con;

  bool released = false;

  _MongoDatabase(this.con);

  void checkForRedirectMap(Map data) {
    if (data.containsKey(REDIRECT_ENTRY_NAME)) {
      throw new Exception("Not inplemented"); //TODO: Implement!
      //throw new api.RedirectingException(data["id"], data[REDIRECT_ENTRY_NAME]);
    }
  }

  Map createRedirectMap(String old_id, String new_id) {
    return {"id": old_id, REDIRECT_ENTRY_NAME: new_id};
  }

  Future<DbCollection> getCollectionsCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_COLLECTIONS_MONGO_COLLECTION);
    return output;
  }

  Future<DbCollection> getFieldsCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_FIELDS_MONGO_COLLECTION);
    return output;
  }

  Future<DbCollection> getItemCopyHistoryCollection() async {
    _checkConnection();

    dynamic output =
        await con.conn.collection(_ITEM_COPY_HISTORY_MONGO_COLLECTION);
    await con.conn.createIndex(_ITEM_COPY_HISTORY_MONGO_COLLECTION,
        keys: {"itemId": 1, "copy": 1});
    return output;
  }

  Future<DbCollection> getItemsCollection() async {
    _checkConnection();
    dynamic output = await con.conn.collection(_ITEMS_MONGO_COLLECTION);
    await con.conn.createIndex(_ITEMS_MONGO_COLLECTION,
        keys: {"name": "text", "copies.uniqueId": "text"});
    await con.conn.createIndex(_ITEMS_MONGO_COLLECTION,
        keys: {ID_FIELD: 1, "copies.copy": 1}, unique: true);
    await con.conn.createIndex(_ITEMS_MONGO_COLLECTION,
        key: "copies.uniqueId", unique: true, sparse: true);
    return output;
  }

  Future<DbCollection> getItemTypesCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_ITEM_TYPES_MONGO_COLLECTION);
    return output;
  }

  Future<DbCollection> getSettingsCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_SETTINGS_MONGO_COLLECTION);
    return output;
  }

  Future<DbCollection> getSetupCollection() async {
    dynamic output = await con.conn.collection("setup");
    return output;
  }

  Future<DbCollection> getTransactionsCollection() async {
    dynamic output = await con.conn.collection("transactions");
    return output;
  }

  Future<DbCollection> getUsersCollection() async {
    _checkConnection();
    DbCollection output = await con.conn.collection(_USERS_MONGO_COLLECTION);
    await con.conn.createIndex(_USERS_MONGO_COLLECTION,
        keys: {"id": "text", "name": "text", "idNumber": "text"});
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

  Future<dynamic> startTransaction() async {
    DbCollection transactions = await getTransactionsCollection();
    transactions.findOne({"state": "initial"});
  }

  void _checkConnection() {
    if (released) throw new Exception("Connection has already been released");
  }

  static Future<_MongoDatabase> getConnection() async {
    if (_pool == null) {
      _pool = new _MongoDbConnectionPool(model.settings.mongoConnectionString, 3);
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

    return new _MongoDatabase(con);
  }
}
