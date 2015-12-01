part of api;

class Item extends AData {
  String template;

  @ApiProperty(required: true)
  Map<String, String> field_values = new Map<String, String>();

  Item();

}