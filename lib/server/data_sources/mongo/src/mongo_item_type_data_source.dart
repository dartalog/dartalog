part of data_sources.mongo;

class MongoItemTypeDataSource extends _AMongoIdDataSource<ItemType>
    with AItemTypeModel {
  static final Logger _log = new Logger('MongoItemTypeDataSource');

  ItemType _createObject(Map data) {
    ItemType template = new ItemType();
    template.getId = data[ID_FIELD];
    template.getName = data["name"];
    template.fieldIds = data["fieldIds"];
    return template;
  }

  Future<DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemTypesCollection();

  void _updateMap(ItemType template, Map data) {
    data[ID_FIELD] = template.getId;
    data["name"] = template.getName;
    data["fieldIds"] = template.fieldIds;
  }
}
