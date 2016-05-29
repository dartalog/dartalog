part of model;

class _MongoItemCollectionModel extends _AMongoIdModel<api.Collection>
    with AItemCollectionModel {
  static final Logger _log = new Logger('_MongoCollectionModel');

  api.Collection _createObject(Map data) {
    api.Collection output = new api.Collection();
    output.id = data["id"];
    output.name = data["name"];
    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getCollectionsCollection();

  void _updateMap(api.Collection collection, Map data) {
    data["id"] = collection.id;
    data["name"] = collection.name;
  }
}
