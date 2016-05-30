part of data_sources;

class _MongoItemCollectionModel extends _AMongoIdModel<Collection>
    with AItemCollectionModel {
  static final Logger _log = new Logger('_MongoCollectionModel');

  Collection _createObject(Map data) {
    Collection output = new Collection();
    output.id = data["id"];
    output.name = data["name"];
    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getCollectionsCollection();

  void _updateMap(Collection collection, Map data) {
    data["id"] = collection.id;
    data["name"] = collection.name;
  }
}
