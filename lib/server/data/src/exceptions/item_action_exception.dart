import 'dart:async';

class ItemActionException implements Exception {
  String message;
  Map<String, String> itemActionErrors = new Map<String, String>();
  ItemActionException(this.message);
  ItemActionException.WithItemActionErrors(this.message, this.itemActionErrors);

  @override
  String toString() {
    return message;
  }

  static Future<Null> performValidation(
      Future<Null> toAwait(Map<String, String> fieldErrors)) async {
    final Map<String, String> itemActionErrors = new Map<String, String>();

    await toAwait(itemActionErrors);

    final Map<String, String> output = <String, String>{};

    for (String id in itemActionErrors.keys) {
      output[id] = itemActionErrors[id];
    }

    if (itemActionErrors.length > 0) {
      throw new ItemActionException.WithItemActionErrors(
          "Item action error", itemActionErrors);
    }
  }
}
