part of api;

class ItemType extends AData {

  @ApiProperty(required: true)
  String id;

  @ApiProperty(required: true)
  String name;

  @ApiProperty(required: true)
  List<String> fields = new List<String>();

  List<String> subTypes = new List<String>();

  List<String> itemNameFields = new List<String>();

  ItemType();

  Future validate(bool verifyId) async {
    Map<String,String> field_errors = new Map<String,String>();
    if(isNullOrWhitespace(this.id))
      field_errors["id"] = "Required";
    else if(verifyId) {
      ItemType it = await model.itemTypes.get(this.id);
      if(it!=null)
        field_errors["id"] = "Already in use";
    }
    if(isNullOrWhitespace(this.name))
      field_errors["name"] = "Required";
    if(this.name.trim()=="name")
      field_errors["name"] = "Cannot be named ""name""";
    if(this.fields==null||this.fields.length==0)
      field_errors["fields"] = "Required";

    if(field_errors.length>0) {
      throw new DataValidationException.WithFieldErrors("Invalid item type data", field_errors);
    }
  }

}