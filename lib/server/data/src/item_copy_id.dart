part of data;

class ItemCopyId extends AData {
  String itemId = "";
  int copy = 0;

  ItemCopyId();

  ItemCopyId.fromItemCopy(ItemCopy itemCopy) {
    this.itemId = itemCopy.itemId;
    this.copy = itemCopy.copy;
  }

  bool matchesItemCopy(ItemCopy itemCopy) {
    return (itemCopy.itemId==this.itemId&&itemCopy.copy==this.copy);
  }
}
