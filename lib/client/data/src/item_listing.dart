part of data;

class ItemListing extends JsProxy {
  @reflectable
  String id;
  @reflectable
  String name;
  @reflectable
  String thumbnail;
  @reflectable
  String typeId;

  ItemListing();

  ItemListing.copy(dynamic field) {
    _copy(field,this);
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.typeId = from.typeId;
    to.thumbnail = from.thumbnail;
  }

  static List<ItemListing> convertList(Iterable input) {
    List<ItemListing> output = new List<ItemListing>();
    for(dynamic obj in input) {
      output.add(new ItemListing.copy(obj));
    }
    return output;
  }

}