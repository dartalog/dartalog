part of api;

class Item extends AData {
  @ApiProperty(required: true)
  String type;

  @ApiProperty(required: true)
  String id = "";

  @ApiProperty(required: true)
  String name = "";

  String parent = "";

  List<String> children = new List<String>();

  @ApiProperty(required: true)
  Map<String, String> fieldValues = new Map<String, String>();


  Item();

  Future validate(bool verifyId) async {
    if(isNullOrWhitespace(this.type))
      throw new BadRequestError("Field ""template"" must have a value");
    if(fieldValues==null)
      throw new BadRequestError("Map ""fieldValues"" is required");
    if(fieldValues.length==0)
      throw new BadRequestError("Map ""fieldValues"" requires at least one field");
  }
}