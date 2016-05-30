part of api;

class Field extends AIdData {
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
  String type;

  String format = "";

  Field();

  Future _getById(String id) => model.fields.getById(id);

  @override
  Future _validateFieldsInternal() async {
    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(this.type))
      field_errors["type"] = "Required";
    else if(FIELD_TYPES.containsKey(this.type)) {
      field_errors["type"] = "Invalid";
    }

    if (!isNullOrWhitespace(this.format)) {
      String test = validateRegularExpression(this.format);
      if (!isNullOrWhitespace(test)) field_errors["format"] = test;
    }
  }
}
