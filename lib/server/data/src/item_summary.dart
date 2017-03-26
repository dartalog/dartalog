import 'item.dart';

class ItemSummary {
  String uuid = "";
  String name = "";
  String typeUuid = "";
  String thumbnail = "";

  ItemSummary();

  ItemSummary.copyObject(dynamic field) {
    _copy(field, this);
  }

  ItemSummary.copyItem(Item o, {String thumbnailField: "front_cover"}) {
    this.uuid = o.uuid;
    this.name = o.name;
    this.typeUuid= o.typeUuid;
    if (o.values == null) throw new Exception("Null value object");

    if (o.values.containsKey(thumbnailField)) {
      this.thumbnail = o.values[thumbnailField];
    }
  }

  void copyTo(dynamic output) {
    _copy(this, output);
  }

  void _copy(dynamic from, dynamic to) {
    to.uuid = from.uuid;
    to.name = from.name;
    to.typeUuid = from.typeUuid;
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
