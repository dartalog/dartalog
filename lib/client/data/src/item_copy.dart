import 'package:dartalog/dartalog.dart';
import 'package:dartalog/tools.dart';
import 'package:polymer/polymer.dart';

import 'collection.dart';
import 'item_summary.dart';

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
  String statusName;
  @reflectable
  String uniqueId;

  @reflectable
  ItemSummary itemSummary;

  @reflectable
  Collection collection;

  List<String> eligibleActions = [];

  @reflectable
  bool inCart = false;
  @reflectable
  String errorMessage = "";
  @reflectable
  bool availableForCheckout = false;

  @reflectable
  bool userCanCheckout = false;

  @reflectable
  bool userCanEdit = false;

  ItemCopy();

  ItemCopy.copyFrom(dynamic input) {
    _copy(input, this);
    availableForCheckout =
        userCanCheckout && eligibleActions.contains(ITEM_ACTION_BORROW);
  }

  ItemCopy.forItem(this.itemId, {this.copy: 0});

  @reflectable
  bool get hasUniqueId => !isNullOrWhitespace(this.uniqueId);

  void copyTo(dynamic output) {
    _copy(this, output);
  }

  bool matches(String itemId, int copy) {
    return itemId == this.itemId && copy == this.copy;
  }

  bool matchesItemCopy(ItemCopy other) {
    return matches(other.itemId, other.copy);
  }

  void _copy(dynamic from, dynamic to) {
    to.collectionId = from.collectionId;
    to.copy = from.copy;
    to.itemId = from.itemId;
    to.status = from.status;
    to.statusName = from.statusName;
    to.uniqueId = from.uniqueId;
    to.eligibleActions = from.eligibleActions;
    to.userCanCheckout = from.userCanCheckout;
    to.userCanEdit = from.userCanEdit;
    if (from.itemSummary != null)
      to.itemSummary = new ItemSummary.copy(from.itemSummary);
    if (from.collection != null)
      to.collection = new Collection.copy(from.collection);
  }
}
