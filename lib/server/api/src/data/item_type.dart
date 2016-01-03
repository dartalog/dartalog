part of api;

class ItemType extends AData {
  @ApiProperty(required: true)
  String name;

  @ApiProperty(required: true)
  List<String> fields = new List<String>();

  ItemType();

  void validate() {
    if(isNullOrWhitespace(this.name))
      throw new BadRequestError("Field ""name"" must have a value");
    if(fields==null)
      throw new BadRequestError("Map ""fields"" is required");
    if(fields.length==0)
      throw new BadRequestError("Map ""fields"" requires at least one field");
  }

}