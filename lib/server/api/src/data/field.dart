part of api;

class Field extends AData {
  @ApiProperty(required: true)
  String name;
  @ApiProperty(required: true)
  String type;

  String format = "";

  Field();
}