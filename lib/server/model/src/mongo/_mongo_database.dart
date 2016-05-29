part of model;

class _MongoDatabase extends ADatabase {
  static final Logger _log = new Logger('_MongoDatabase');
  static _MongoDbConnectionPool _pool;

  static const String _SETTINGS_MONGO_COLLECTION = "settings";
  static const String _ITEMS_MONGO_COLLECTION = "items";
  static const String _FIELDS_MONGO_COLLECTION = "fields";
  static const String _ITEM_TYPES_MONGO_COLLECTION = "itemTypes";
  static const String _ITEM_COPIES_MONGO_COLLECTION = "itemCopies";
  static const String _COLLECTIONS_MONGO_COLLECTION = "collection";

  static String REDIRECT_ENTRY_NAME = "redirect";
  ManagedConnection<mongo.Db> con;

  bool released = false;

  _MongoDatabase(this.con);

  void checkForRedirectMap(Map data) {
    if (data.containsKey(REDIRECT_ENTRY_NAME)) {
      throw new api.RedirectingException(data["id"], data[REDIRECT_ENTRY_NAME]);
    }
  }

  Map createRedirectMap(String old_id, String new_id) {
    return {"id": old_id, REDIRECT_ENTRY_NAME: new_id};
  }

  Future<mongo.DbCollection> getCollectionsCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_COLLECTIONS_MONGO_COLLECTION);
    await con.conn
        .createIndex(_COLLECTIONS_MONGO_COLLECTION, key: "id", unique: true);
    return output;
  }

  Future<mongo.DbCollection> getFieldsCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_FIELDS_MONGO_COLLECTION);
    await con.conn
        .createIndex(_FIELDS_MONGO_COLLECTION, key: "id", unique: true);
    return output;
  }

  Future<mongo.DbCollection> getItemCopiesCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_ITEM_COPIES_MONGO_COLLECTION);
    await con.conn
        .createIndex(_ITEM_COPIES_MONGO_COLLECTION, keys: {"itemId": 1, "copy": 1}, unique: true);
    await con.conn
        .createIndex(_ITEM_COPIES_MONGO_COLLECTION, keys: {"itemId": 1});
    await con.conn
        .createIndex(_ITEM_COPIES_MONGO_COLLECTION, key: "uniqueId", unique: true, sparse: true);
    return output;
  }

  Future<mongo.DbCollection> getItemsCollection() async {
    _checkConnection();
    dynamic output = await con.conn.collection(_ITEMS_MONGO_COLLECTION);
    await con.conn
        .createIndex(_ITEMS_MONGO_COLLECTION, key: "id", unique: true);
    return output;
  }

  Future<mongo.DbCollection> getItemTypesCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_ITEM_TYPES_MONGO_COLLECTION);
    await con.conn
        .createIndex(_ITEM_TYPES_MONGO_COLLECTION, key: "id", unique: true);
    return output;
  }

  Future<mongo.DbCollection> getSettingsCollection() async {
    _checkConnection();

    dynamic output = await con.conn.collection(_SETTINGS_MONGO_COLLECTION);
    await con.conn
        .createIndex(_SETTINGS_MONGO_COLLECTION, key: "id", unique: true);
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

  void _checkConnection() {
    if (released) throw new Exception("Connection has already been released");
  }

  static Future<_MongoDatabase> getConnection() async {
    if (_pool == null) {
      _pool = new _MongoDbConnectionPool(_AModel.options.getString("mongo"), 3);
    }

    ManagedConnection con = await _pool.getConnection();
    mongo.Db db = con.conn;

    int i = 0;
    while (db == null || db.state != mongo.State.OPEN) {
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
