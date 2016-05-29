part of model;

class _MongoItemModel extends _AMongoIdModel<api.Item> with AItemModel {
  static final Logger _log = new Logger('_MongoItemModel');

  api.Item _createObject(Map data) {
    api.Item output = new api.Item();

    output.id = data['id'];
    output.name = data['name'];
    output.typeId = data['typeId'];
    output.values = data["values"];
    output.copyCount = data["copyCount"];

    return output;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemsCollection();

  void _updateMap(api.Item item, Map data) {
    data["id"] = item.id;
    data["name"] = item.name;
    data["typeId"] = item.typeId;
    data["values"] = item.values;
    if(item.copyCount!=null&&item.copyCount>0)
      data["copyCount"] = item.copyCount;
  }
}
