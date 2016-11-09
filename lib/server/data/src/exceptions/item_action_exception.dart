import 'dart:async';
import '../item_copy_id.dart';

class ItemActionException implements Exception {
  String message;
  Map<ItemCopyId, String> itemActionErrors = new Map<ItemCopyId, String>();
  ItemActionException(this.message);
  ItemActionException.WithItemActionErrors(this.message, this.itemActionErrors);

  @override
  String toString() {
    return message;
  }

  static Future<Null> PerformValidation(
      Future<Null> toAwait(Map<ItemCopyId, String> fieldErrors)) async {
    final Map<ItemCopyId, String> itemActionErrors =
        new Map<ItemCopyId, String>();

    await toAwait(itemActionErrors);

    final Map<String, String> output = <String, String>{};

    for (ItemCopyId id in itemActionErrors.keys) {
      output[id.toString()] = itemActionErrors[id];
    }

    if (itemActionErrors.length > 0) {
      throw new ItemActionException.WithItemActionErrors(
          "Item action error", itemActionErrors);
    }
  }
}
