import 'a_human_friendly_data.dart';
import 'collection.dart';
import 'item_summary.dart';
import 'dart:convert';
import 'a_uuid_data.dart';

class ItemCopy extends AUuidData {
  String itemUuid = "";
  String collectionUuid = "";
  String uniqueId = "";
  String status = "";
  String statusName = "";

  bool userCanCheckout = false;
  bool userCanEdit = false;

  List<String> eligibleActions = [];
  Collection collection;
  ItemSummary itemSummary;

  ItemCopy();

  ItemCopy.copyItem(ItemCopy o): super.copy(o) {
    this.itemUuid = o.itemUuid;
    this.collectionUuid = o.collectionUuid;
    this.collection = o.collection;
    this.uniqueId = o.uniqueId;
    this.status = o.status;
  }

  void cleanUp() {
    this.uniqueId = this.uniqueId.trim();
  }

  @override
  String toString() {
    throw new Exception("Don't call this");
  }
}
