part of api;

class ItemListing {
  String id = "";
  String name = "";
  String typeId = "";
  String thumbnail = "";

  ItemListing();

  ItemListing.copy(Item o) {
    this.id = o.id;
    this.name = o.name;
    this.typeId = o.typeId;
    if(o.values.containsKey("front_cover")) {
      this.thumbnail= o.values["front_cover"];
    }
  }

  static List<ItemListing> convertList(Iterable<Item> i) {
    List<ItemListing> output = new List<ItemListing>();
    for(Item o in i) {
      output.add(new ItemListing.copy(o));
    }
    return output;
  }
}