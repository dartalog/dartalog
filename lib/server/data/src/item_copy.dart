import 'a_id_data.dart';
import 'collection.dart';
import 'item_summary.dart';
import 'dart:convert';

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

  ItemCopy.copyItem(ItemCopy o) {
    this.itemId = o.itemId;
    this.copy = o.copy;
    this.collectionId = o.collectionId;
    this.collection = o.collection;
    this.uniqueId = o.uniqueId;
    this.status = o.status;
  }

  void cleanUp() {
    this.uniqueId = this.uniqueId.trim();
  }

  @override
  String toString() {
    return JSON
        .encode(<String, dynamic>{"itemId": this.itemId, "copy": this.copy});
  }
}
