part of data_sources.mongo;

class MongoSetupDataSource extends _AMongoDataSource with ASetupDataSource {
  static final Logger _log = new Logger('MongoSetupDataSource');

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getSetupCollection();

  Future<bool> isSetup() async {
    dynamic selector = where.eq(ID_FIELD, "setup");
    dynamic output = await this._genericFind(selector);
    if(output==null)
      return false;
  }

  Future markAsSetup() async {
    dynamic selector = where.eq(ID_FIELD, "setup");
    await this._deleteFromDb(selector);
  }


  Future<String> getVersion() async => "1.0";
  Future setVersion(String version) {}
}
