part of api;

class Item extends AData {

  String template;

  @ApiProperty(required: true)
  Map<String, String> fieldValues = new Map<String, String>();

  Item();

  void validate() {
    if(isNullOrWhitespace(this.template))
      throw new BadRequestError("Field ""template"" must have a value");
    if(fieldValues==null)
      throw new BadRequestError("Map ""fieldValues"" is required");
    if(fieldValues.length==0)
      throw new BadRequestError("Map ""fieldValues"" requires at least one field");
  }
}