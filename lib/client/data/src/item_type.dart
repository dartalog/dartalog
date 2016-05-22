part of data;

class ItemType extends JsProxy {
  @reflectable
  String id = "";
  @reflectable
  String name = "";
  @reflectable
  List<String> fieldIds = new List<String>();
  @reflectable
  List<String> subTypes = new List<String>();
  @reflectable
  List<String> itemNameFields = new List<String>();

  @reflectable
  List<Field> fields;

  ItemType();

  ItemType.copy(dynamic field) {
    _copy(field,this);
    if(this.fieldIds==null)
      this.fieldIds = new List<String>();
    if(field.fields!=null)
      this.fields = Field.convertList(field.fields);
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.fieldIds = from.fieldIds;
//    to.subTypes = from.subTypes;
//    to.itemNameFields = from.itemNameFields;
  }

  static List<ItemType> convertList(Iterable input) {
    List<ItemType> output = new List<ItemType>();
    for(dynamic obj in input) {
      output.add(new ItemType.copy(obj));
    }
    return output;
  }
}