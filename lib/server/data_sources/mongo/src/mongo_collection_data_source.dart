part of data_sources.mongo;

class MongoCollectionDataSource extends _AMongoIdDataSource<Collection>
    with AItemCollectionModel {
  static final Logger _log = new Logger('MongoItemCollectionDataSource');

  Collection _createObject(Map data) {
    Collection output = new Collection();
    output.getId = data[ID_FIELD];
    output.getName = data["name"];
    return output;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getCollectionsCollection();

  void _updateMap(Collection collection, Map data) {
    data[ID_FIELD] = collection.getId;
    data["name"] = collection.getName;
  }
}
