part of api;

class Field extends AData {

  @ApiProperty(required: true)
  String name;
  @ApiProperty(required: true)
  String type;

  String format = "";

  Field();

  void validate() {
    Map<String,String> field_errors = new Map<String,String>();
    if(isNullOrWhitespace(this.name))
      field_errors["name"] = "Required";
    if(isNullOrWhitespace(this.type))
      field_errors["type"] = "Required";
    if(!isNullOrWhitespace(this.format)) {
      String test = validateRegularExpression(this.format);
      if(!isNullOrWhitespace(test))
        field_errors["format"] = test;
    }

    if(field_errors.length>0) {
      throw new DataValidationException.WithFieldErrors("Invalid field data", field_errors);
    }
  }

  Field.fromData(Map data) {
    name = data["name"];
    format = data["format"];
    type = data["type"];
  }
}