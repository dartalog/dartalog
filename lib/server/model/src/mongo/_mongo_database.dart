part of model;

class _MongoDatabase {
  static _MongoDbConnectionPool _pool;

  static const String _ITEMS_MONGO_COLLECTION = "items";
  static const String _FIELDS_MONGO_COLLECTION = "fields";
  static const String _TEMPLATES_MONGO_COLLECTION = "templates";

  ManagedConnection<mongo.Db> con;
  bool released = false;

  _MongoDatabase(this.con);

  static Future<_MongoDatabase> getConnection() async {
    if(_pool==null) {
      _pool = new _MongoDbConnectionPool(_AModel.options.getString("mongo"), 3);
    }


    ManagedConnection con = await _pool.getConnection();
    mongo.Db db = con.conn;

    int i = 0;
    while(db==null||db.state!=mongo.State.OPEN) {
      if(i>5) {
        throw new Exception("Too many attempts to fetch a connection from the pool");
      }
      if(con!=null) {
        _log.info("Mongo database connection has issue, returning to pool and re-fetching");
        _pool.releaseConnection(con, markAsInvalid: true);
      }
      con = await _pool.getConnection();
      db = con.conn;
      i++;
    }

    return new _MongoDatabase(con);
  }

  void release({bool dispose: false}) {
    if(released)
      return;
    if(dispose) {
      _pool.releaseConnection(con, markAsInvalid: true);
    } else {
      _pool.releaseConnection(con);
    }
    con = null;
    released = true;
  }

  void _checkConnection() {
    if(released)
      throw new Exception("Connection has already been released");
  }

  Future<mongo.DbCollection> getItemsCollection() async {
    _checkConnection();
    return await con.conn.collection(_ITEMS_MONGO_COLLECTION);
  }
  Future<mongo.DbCollection> getFieldsCollection() async {
    _checkConnection();
    return await con.conn.collection(_FIELDS_MONGO_COLLECTION);
  }
  Future<mongo.DbCollection> getTemplatesCollection() async {
    _checkConnection();
    return await con.conn.collection(_TEMPLATES_MONGO_COLLECTION);
  }

}