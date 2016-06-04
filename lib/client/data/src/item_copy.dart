part of data;
class ItemCopy extends JsProxy {
  @reflectable
  String collectionId;
  @reflectable
  String collectionName;
  @reflectable
  int copy = 0;
  @reflectable
  String itemId;
  @reflectable
  String itemName;
  @reflectable
  String status;
  @reflectable
  String statusName;
  @reflectable
  String uniqueId;

  List<String> eligibleActions = [];

  @reflectable
  bool inCart = false;
  @reflectable
  String errorMessage = "";
  @reflectable
  bool availableForCheckout = false;

  ItemCopy();

  ItemCopy.forItem(this.itemId);

  ItemCopy.copyFrom(dynamic input) {
    _copy(input,this);
    availableForCheckout = eligibleActions.contains(ITEM_ACTION_BORROW);
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.collectionId = from.collectionId;
    to.collectionName = from.collectionName;
    to.copy = from.copy;
    to.itemId = from.itemId;
    to.itemName = from.itemName;
    to.status = from.status;
    to.statusName = from.statusName;
    to.uniqueId = from.uniqueId;
    to.eligibleActions = from.eligibleActions;
  }

  bool matchesItemCopy(ItemCopy other) {
    return matches(other.itemId, other.copy);
  }

  bool matches(String itemId, int copy) {
    return itemId==this.itemId&&copy==this.copy;
  }


}