part of api;

class Template extends AData {
  @ApiProperty(required: true)
  String name;

  @ApiProperty(required: true)
  Map<String,Field> fields = new Map<String,Field>();

  Template();

}