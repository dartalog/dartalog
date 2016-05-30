part of data;

class Field extends AIdData {
  String _id = "";
  String get id => _id;
  set id(String value) => _id = value;

  String _name = "";
  String get name => _name;
  set name(String value) => _name = value;

  String type;

  String format = "";

  Field();


}
