part of api;

class Item extends AIdData {
  @ApiProperty(required: false)
  String id = "";
  String get _id => id;
  set _id(String value) => id = value;

  @override
  @ApiProperty(required: true)
  String name = "";
  String get _name => name;
  set _name(String value) => name = value;

  @ApiProperty(required: true)
  String typeId;

  @ApiProperty(required: true)
  Map<String, String> values = new Map<String, String>();

  List<String> fileUploads = new List<String>();

  @ApiProperty(ignore: true)
  int copyCount = 0;

  List<ItemCopy> copies;
  ItemType type;

  Item();

  Future _getById(String id) => model.items.getById(id);

  @override
  Future _validateFieldsInternal() async {
    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(this.typeId))
      field_errors["typeId"] = "Required";
    else {
      dynamic test  = model.itemTypes.getById(this.typeId);
      if(test==null)
        field_errors["typeId"] = "Not found";
    }

    return field_errors;
  }
}
