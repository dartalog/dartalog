part of api;

class Field extends AData {
  @ApiProperty(required: true)
  String name;
  @ApiProperty(required: true)
  String type;

  String format = "";

  Field();

  void validate() {
    if(isNullOrWhitespace(this.name))
      throw new BadRequestError("Field ""name"" must have a value");
    if(isNullOrWhitespace(this.type))
      throw new BadRequestError("Field ""type"" must have a value");
  }
}