part of data;

class ItemType extends JsProxy {
  @reflectable
  String id = "";
  @reflectable
  String name = "";
  @reflectable
  List<String> fields = new List<String>();
  @reflectable
  List<String> subTypes = new List<String>();
  @reflectable
  List<String> itemNameFields = new List<String>();

  ItemType();

  ItemType.copy(dynamic field) {
    _copy(field,this);
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.fields = from.fields;
    to.subTypes = from.subTypes;
    to.itemNameFields = from.itemNameFields;
  }

  static List<ItemType> convertList(Iterable input) {
    List<ItemType> output = new List<ItemType>();
    for(dynamic obj in input) {
      output.add(new ItemType.copy(obj));
    }
    return output;
  }
}