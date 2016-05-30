part of data;

class _MongoItemTypeModel extends _AMongoIdModel<api.ItemType>
    with AItemTypeModel {
  static final Logger _log = new Logger('_MongoItemTypeModel');

  api.ItemType _createObject(Map data) {
    api.ItemType template = new api.ItemType();
    template.id = data["id"];
    template.name = data["name"];
    template.fieldIds = data["fieldIds"];
    return template;
  }

  Future<mongo.DbCollection> _getCollection(_MongoDatabase con) =>
      con.getItemTypesCollection();

  void _updateMap(api.ItemType template, Map data) {
    data["id"] = template.id;
    data["name"] = template.name;
    data["fieldIds"] = template.fieldIds;
  }
}
