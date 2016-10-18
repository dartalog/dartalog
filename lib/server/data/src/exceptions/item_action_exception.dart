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
      Future toAwait(Map<ItemCopyId, String> field_errors)) async {
    Map<ItemCopyId, String> item_action_errors = new Map<ItemCopyId, String>();

    await toAwait(item_action_errors);

    if (item_action_errors.length > 0) {
      throw new ItemActionException.WithItemActionErrors(
          "Item action error", item_action_errors);
    }
  }
}
