part of data;
class ItemCopy extends JsProxy {
  @reflectable
  String collectionId;
  @reflectable
  int copy = 0;
  @reflectable
  String itemId;
  @reflectable
  String status;
  @reflectable
  String uniqueId;

  ItemCopy();

  ItemCopy.forItem(this.itemId);

  ItemCopy.copyFrom(dynamic input) {
    _copy(input,this);
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.collectionId = from.collectionId;
    to.copy = from.copy;
    to.itemId = from.itemId;
    to.status = from.status;
    to.uniqueId = from.uniqueId;
  }

  bool matches(ItemCopy other) {
    return other.itemId==this.itemId&&other.copy==this.copy;
  }
}