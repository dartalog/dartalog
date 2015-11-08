part of model;

class Field extends AData {
  @ApiProperty(required: true)
  String name;
  @ApiProperty(required: true)
  String type;
  String format = "";

  Field();

  Field.fromData(dynamic data) {
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