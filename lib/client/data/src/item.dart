part of data;
class Item {
  @reflectable
  String id;
  @reflectable
  String name;
  @reflectable
  String typeId;
  @reflectable
  ItemType type;

  @Property(notify: true)
  List<Field> fields;

  Map<String,String> get values {
    Map<String,String> output = new Map<String,String>();
    for(Field f in fields) {
      output[f.id] = f.value;
    }
    return output;
  }

  Item();

  Item.forType(ItemType type) {
    this.typeId = type.id;
    this.fields = type.fields;
    this.type = type;
  }

  Item.copy(dynamic input) {
    if(input.type!=null)
      this.type  = new ItemType.copy(input.type);
    _copy(input,this);
  }

  String getFieldValue(String id) {
    return values[id];
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.typeId = from.typeId;
    to.values = from.values;
  }

}