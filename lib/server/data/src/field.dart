import 'a_id_data.dart';

class Field extends AIdData {
  String id = "";
  String name = "";
  String readableId = "";

  bool unique = false;

  String type;
  String format = "";
  Field();

  Field.copy(dynamic from) {
    copyObject(from, this);
  }

  Field.fromValues(this.id, this.name, this.readableId, this.type,
      {this.unique: false, this.format: ""});

  @override
  String get getId => id;

  @override
  String get getName => name;

  @override
  String get getReadableId => readableId;
  @override
  set setId(String value) => id = value;
  @override
  set setName(String value) => name = value;

  @override
  set setReadableId(String value) => readableId = value;

  void copyObject(dynamic from, dynamic to) {
    to.format = from.format;
    to.id = from.id;
    to.name = from.name;
    to.type = from.type;
    to.unique = from.unique;
  }
}
