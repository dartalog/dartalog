part of data_sources;

class _MongoItemModel extends _AMongoIdModel<Item> with AItemModel {
  static final Logger _log = new Logger('_MongoItemModel');

  Item _createObject(Map data) {
    Item output = new Item();

    output.id = data['id'];
    output.name = data['name'];
    output.typeId = data['typeId'];
    output.values = data["values"];
    output.copyCount = data["copyCount"];

    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemsCollection();

  void _updateMap(Item item, Map data) {
    data["id"] = item.id;
    data["name"] = item.name;
    data["typeId"] = item.typeId;
    data["values"] = item.values;
    if(item.copyCount!=null&&item.copyCount>0)
      data["copyCount"] = item.copyCount;
  }
}
