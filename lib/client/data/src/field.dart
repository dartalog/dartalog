part of data;

class Field extends JsProxy {
  @reflectable
  String format = "";
  @reflectable
  String id = "";
  @reflectable
  String name = "";
  @reflectable
  String type = "";

  Field();

  Field.copy(dynamic field) {
    _copy(field,this);
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.format = from.format;
    to.id = from.id;
    to.name = from.name;
    to.type = from.type;
  }
}