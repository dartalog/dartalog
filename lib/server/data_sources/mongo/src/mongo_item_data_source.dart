part of data_sources.mongo;

class MongoItemDataSource extends _AMongoIdDataSource<Item>
    with AItemDataSource {
  static final Logger _log = new Logger('MongoItemDataSource');

  Item _createObject(Map data) {
    Item output = new Item();

    output.id = data[ID_FIELD];
    output.getName = data['name'];
    output.typeId = data['typeId'];
    output.values = data["values"];
    output.dateAdded = data["dateAdded"];
    output.dateUpdated = data["dateUpdated"];

    return output;
  }



  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemsCollection();

  void _updateMap(Item item, Map data) {
    data[ID_FIELD] = item.id;
    data["name"] = item.getName;
    data["typeId"] = item.typeId;
    data["values"] = item.values;
    if(item.dateAdded!=null)
      data["dateAdded"] = item.dateAdded;
    data["dateUpdated"] = item.dateUpdated;
  }
}
