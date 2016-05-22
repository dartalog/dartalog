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

  @Property(notify: true) String value = "";

  @reflectable bool isTypeString = false;
  @reflectable bool isTypeImage = false;

  Field();

  Field.copy(dynamic field) {
    _copy(field,this);
    switch(this.type) {
      case "string":
      case "hidden":
        isTypeString = true;
        break;
      case "image":
        isTypeImage = true;
        break;
    }
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

  static List<Field> convertList(Iterable input) {
    List<Field> output = new List<Field>();
    for(dynamic obj in input) {
      output.add(new Field.copy(obj));
    }
    return output;
  }

}