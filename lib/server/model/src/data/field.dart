part of model;

class Field {
  String id;
  String uuid;
  String name;
  String type;
  String format = "";

  Field();

  Field.fromData(dynamic data) {
    this.uuid = formatUuid(data.uuid);
    this.name = data.name;
    this.type = data.type;
    this.format = data.format;
  }

}