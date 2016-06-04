part of data;

class ItemActionException implements  Exception {
  String message;
  Map<ItemCopyId,String> itemActionErrors = new Map<ItemCopyId,String>();
  ItemActionException(this.message);
  ItemActionException.WithItemActionErrors(this.message, this.itemActionErrors);

  String toString() {
    return message;
  }

  static Future PerformValidation(Future<Map<ItemCopyId,String>> toAwait()) async {
    Map<ItemCopyId,String> item_action_errors = await toAwait();

    if (item_action_errors.length > 0) {
      throw new ItemActionException.WithItemActionErrors(
          "Item action error", item_action_errors);
    }
  }

}

