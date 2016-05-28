part of api;

class Item extends AData {
  @ApiProperty(required: false)
  String id = "";

  @ApiProperty(required: true)
  String name = "";

  @ApiProperty(required: true)
  String typeId;

  @ApiProperty(required: true)
  Map<String, String> values = new Map<String, String>();

  List<String> fileUploads = new List<String>();

  ItemType type;

  Item();

  Future validate(bool verifyId) async {
    Map<String,String> field_errors = new Map<String,String>();

    if(!isNullOrWhitespace(this.id)&&verifyId) {
      Item f = await model.items.get(id);
      if(f!=null)
        field_errors["id"] = "Already in use";
    }

    if(isNullOrWhitespace(this.name))
      field_errors["name"] = "Required";
    if(this.name.trim()=="name")
      field_errors["name"] = "Cannot be named ""name""";

    if(isNullOrWhitespace(this.typeId))
      field_errors["typeId"] = "Required";

    if(field_errors.length>0) {
      throw new DataValidationException.WithFieldErrors("Invalid item data", field_errors);
    }
  }
}