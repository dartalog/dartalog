part of api;

class ItemCopyHistoryEntry {
  @ApiProperty(required: true)
  String itemId = "";
  @ApiProperty(required: true)
  int copy = 1;
  @ApiProperty(required: true)
  String collectionId = "";
  @ApiProperty(required: false)
  String uniqueId = "";
  @ApiProperty(required: false)
  String status = "";

  Collection collection;

  ItemCopy();

  ItemCopy.copyItem(ItemCopy o) {
    this.itemId = o.itemId;
    this.copy = o.copy;
    this.collectionId = o.collectionId;
    this.collection = o.collection;
    this.uniqueId = o.uniqueId;
    this.status = o.status;
  }

  static List<ItemCopy> convertList(Iterable<ItemCopy> i) {
    List<ItemCopy> output = new List<ItemCopy>();
    for (ItemCopy o in i) {
      output.add(new ItemCopy.copyItem(o));
    }
    return output;
  }
}
