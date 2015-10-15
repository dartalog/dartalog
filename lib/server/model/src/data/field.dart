part of model;

class Field extends ORM.Model {
  @ORM.DBField()
  @ORM.DBFieldPrimaryKey()
  @ORM.DBFieldType()
  String uuid;

  @ORM.DBField()
  String name;

  @ORM.DBField()
  String type;

  @ORM.DBField()
  String format = "";

  Field();

  Field.fromData(dynamic data) {
    this.uuid = formatUuid(data.uuid);
    this.name = data.name;
    this.type = data.type;
    this.format = data.format;
  }

}