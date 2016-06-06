part of data_sources;

class _MongoItemCollectionModel extends _AMongoIdDataSource<Collection>
    with AItemCollectionModel {
  static final Logger _log = new Logger('_MongoCollectionModel');

  Collection _createObject(Map data) {
    Collection output = new Collection();
    output.getId = data["id"];
    output.getName = data["name"];
    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getCollectionsCollection();

  void _updateMap(Collection collection, Map data) {
    data["id"] = collection.getId;
    data["name"] = collection.getName;
  }
}
