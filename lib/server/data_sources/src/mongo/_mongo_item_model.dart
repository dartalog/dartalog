part of data_sources;

class _MongoItemModel extends _AMongoIdModel<Item> with AItemModel {
  static final Logger _log = new Logger('_MongoItemModel');

  Item _createObject(Map data) {
    Item output = new Item();

    output.getId = data['id'];
    output.getName = data['name'];
    output.typeId = data['typeId'];
    output.values = data["values"];

    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemsCollection();

  void _updateMap(Item item, Map data) {
    data["id"] = item.getId;
    data["name"] = item.getName;
    data["typeId"] = item.typeId;
    data["values"] = item.values;
  }
}
