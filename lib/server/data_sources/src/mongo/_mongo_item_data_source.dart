part of data_sources;

class _MongoItemDataSource extends _AMongoIdDataSource<Item>
    with AItemDataSource {
  static final Logger _log = new Logger('_MongoItemDataSource');

  Item _createObject(Map data) {
    Item output = new Item();

    output.getId = data['id'];
    output.getName = data['name'];
    output.typeId = data['typeId'];
    output.values = data["values"];

    return output;
  }

  Future<List<Item>> search(String query) async {
    mongo.SelectorBuilder selector = mongo.where;
    selector.map["\$text"] = {"\$search": query};
    return await _getFromDb(selector);
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
