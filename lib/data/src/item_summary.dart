import 'item.dart';

class ItemSummary {
  String id = "";
  String name = "";
  String typeId = "";
  String thumbnail = "";

  ItemSummary();

  ItemSummary.copyObject(dynamic field) {
    _copy(field, this);
  }

  ItemSummary.copyItem(Item o, {String thumbnailField: "front_cover"}) {
    this.id = o.id;
    this.name = o.name;
    this.typeId = o.typeId;
    if (o.values == null) throw new Exception("Null value object");

    if (o.values.containsKey(thumbnailField)) {
      this.thumbnail = o.values[thumbnailField];
    }
  }

  void copyTo(dynamic output) {
    _copy(this, output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.typeId = from.typeId;
    to.thumbnail = from.thumbnail;
  }

  static List<ItemSummary> convertItemList(Iterable<Item> i) {
    final List<ItemSummary> output = new List<ItemSummary>();
    for (Item o in i) {
      output.add(new ItemSummary.copyItem(o));
    }
    return output;
  }

  static List<ItemSummary> convertObjectList(Iterable<dynamic> input) {
    final List<ItemSummary> output = new List<ItemSummary>();
    for (dynamic obj in input) {
      output.add(new ItemSummary.copyObject(obj));
    }
    return output;
  }
}
