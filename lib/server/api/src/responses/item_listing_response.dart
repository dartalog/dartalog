part of api;

class ItemListingResponse {
  String id = "";
  String name = "";
  String typeId = "";
  String thumbnail = "";

  ItemListingResponse();

  ItemListingResponse.copy(Item o) {
    this.id = o.id;
    this.name = o.name;
    this.typeId = o.typeId;
    if (o.values.containsKey("front_cover")) {
      this.thumbnail = o.values["front_cover"];
    }
  }

  static List<ItemListingResponse> convertList(Iterable<Item> i) {
    List<ItemListingResponse> output = new List<ItemListingResponse>();
    for (Item o in i) {
      output.add(new ItemListingResponse.copy(o));
    }
    return output;
  }
}
