part of model;

class Item extends AData {
  @ApiProperty(required: true)
  String parent;
  @ApiProperty(required: true)
  String type;
  String format = "";

  Item();

  Item.fromData(dynamic data) {
    this.name = data["name"];
    this.type = data["type"];
    this.format = data["format"];
  }

  void setData(dynamic data) {
    data["name"] = this.name;
    data["type"] = this.type;
    data["format"] = this.format;
  }
}