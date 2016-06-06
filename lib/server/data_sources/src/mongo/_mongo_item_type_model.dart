part of data_sources;

class _MongoItemTypeModel extends _AMongoIdDataSource<ItemType>
    with AItemTypeModel {
  static final Logger _log = new Logger('_MongoItemTypeModel');

  ItemType _createObject(Map data) {
    ItemType template = new ItemType();
    template.getId = data["id"];
    template.getName = data["name"];
    template.fieldIds = data["fieldIds"];
    return template;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemTypesCollection();

  void _updateMap(ItemType template, Map data) {
    data["id"] = template.getId;
    data["name"] = template.getName;
    data["fieldIds"] = template.fieldIds;
  }
}
