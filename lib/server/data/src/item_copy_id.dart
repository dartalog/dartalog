import 'package:dartalog/data/src/a_data.dart';
import 'package:dartalog/data/src/item_copy.dart';
import 'dart:convert';

class ItemCopyId extends AData {
  String itemId = "";
  int copy = 0;

  ItemCopyId();

  ItemCopyId.fromItemCopy(ItemCopy itemCopy) {
    this.itemId = itemCopy.itemId;
    this.copy = itemCopy.copy;
  }

  bool matchesItemCopy(ItemCopy itemCopy) {
    return (itemCopy.itemId == this.itemId && itemCopy.copy == this.copy);
  }

  @override
  String toString() {
    return JSON
        .encode(<String, dynamic>{"itemId": this.itemId, "copy": this.copy});
  }
}
