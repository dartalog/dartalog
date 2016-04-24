part of api;

class ItemType extends AData {

  @ApiProperty(required: true)
  String name;

  @ApiProperty(required: true)
  List<String> fields = new List<String>();

  ItemType();

  void validate() {
    Map<String,String> field_errors = new Map<String,String>();
    if(isNullOrWhitespace(this.name))
      field_errors["name"] = "Required";
    if(this.fields==null||this.fields.length==0)
      field_errors["fields"] = "Required";

    if(field_errors.length>0) {
      throw new DataValidationException.WithFieldErrors("Invalid item type data", field_errors);
    }
  }

}