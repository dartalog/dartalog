part of data;

class ItemCopy extends AData {
  String itemId = "";
  int copy = 0;
  String collectionId = "";
  String uniqueId = "";
  String status = "";
  String statusName = "";

  bool userCanCheckout = false;
  bool userCanEdit = false;

  List<String> eligibleActions = [];
  Collection collection;
  ItemSummary itemSummary;

  ItemCopy();

  void cleanUp() {
    this.uniqueId = this.uniqueId.trim();
  }

  ItemCopy.copyItem(ItemCopy o) {
    this.itemId = o.itemId;
    this.copy = o.copy;
    this.collectionId = o.collectionId;
    this.collection = o.collection;
    this.uniqueId = o.uniqueId;
    this.status = o.status;
  }

}
