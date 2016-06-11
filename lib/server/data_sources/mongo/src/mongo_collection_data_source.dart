part of data_sources.mongo;

class MongoCollectionDataSource extends _AMongoIdDataSource<Collection>
    with ACollectionDataSource {
  static final Logger _log = new Logger('MongoItemCollectionDataSource');

  static const String PUBLICLY_BROWSABLE_FIELD = "publiclyBrowsable";
  static const String CURATORS_FIELD = "curators";
  static const String BROWSERS_FIELD = "browsers";

  Future<List<Collection>> getAllForCurator(String userId)  async {
    SelectorBuilder selector = where.eq(CURATORS_FIELD, userId);
    return await _getFromDb(selector);
  }

  Future<List<Collection>> getVisibleCollections(String userId) async {
    SelectorBuilder selector = where.eq(PUBLICLY_BROWSABLE_FIELD, true)
        .or(where.eq(CURATORS_FIELD, userId))
        .or(where.eq(BROWSERS_FIELD, userId));
    return await _getFromDb(selector);
  }


  Collection _createObject(Map data) {
    Collection output = new Collection();
    output.id = data[ID_FIELD];
    output.name= data[NAME_FIELD];
    if(data.containsKey(PUBLICLY_BROWSABLE_FIELD))
      output.publiclyBrowsable = data[PUBLICLY_BROWSABLE_FIELD];
    if(data.containsKey(CURATORS_FIELD))
      output.curators = data[CURATORS_FIELD];
    if(data.containsKey(BROWSERS_FIELD))
      output.browsers = data[BROWSERS_FIELD];
    return output;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getCollectionsCollection();

  void _updateMap(Collection collection, Map data) {
    data[ID_FIELD] = collection.id;
    data[NAME_FIELD] = collection.name;
    data[PUBLICLY_BROWSABLE_FIELD] = collection.publiclyBrowsable;
    data[CURATORS_FIELD] = collection.curators;
    data[BROWSERS_FIELD] = collection.browsers;
  }
}
