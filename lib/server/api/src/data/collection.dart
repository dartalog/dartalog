part of api;

class Collection extends AIdData {
  @ApiProperty(required: false)
  String id = "";
  String get _id => id;
  set _id(String value) => id = value;

  @override
  @ApiProperty(required: true)
  String name = "";
  String get _name => name;
  set _name(String value) => name = value;

  Collection();

  Future _getById(String id) => model.itemCollections.getById(id);
}
