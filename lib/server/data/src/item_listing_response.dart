part of data;

class ItemSummary {
  String id = "";
  String name = "";
  String typeId = "";
  String thumbnail = "";

  ItemSummary();

  ItemSummary.copy(Item o, {String thumbnailField: "front_cover"}) {
    this.id = o.id;
    this.name = o.name;
    this.typeId = o.typeId;
    if (o.values.containsKey(thumbnailField)) {
      this.thumbnail = o.values[thumbnailField];
    }
  }

  static List<ItemSummary> convertList(Iterable<Item> i) {
    List<ItemSummary> output = new List<ItemSummary>();
    for (Item o in i) {
      output.add(new ItemSummary.copy(o));
    }
    return output;
  }
}
