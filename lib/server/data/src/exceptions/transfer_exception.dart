import 'dart:async';
import '../item_copy_id.dart';

class TransferException implements Exception {
  String message;
  Map<ItemCopyId, String> transferErrors = new Map<ItemCopyId, String>();
  TransferException(this.message);
  TransferException.WithItemActionErrors(this.message, this.transferErrors);

  @override
  String toString() {
    return message;
  }

  static Future<Null> PerformValidation(
      Future<Null> toAwait(Map<ItemCopyId, String> transferErrors)) async {
    final Map<ItemCopyId, String> transferErrors =
        new Map<ItemCopyId, String>();

    await toAwait(transferErrors);

    final Map<String, String> output = <String, String>{};

    for (ItemCopyId id in transferErrors.keys) {
      output[id.toString()] = transferErrors[id];
    }

    if (transferErrors.length > 0) {
      throw new TransferException.WithItemActionErrors(
          "Transfer error", transferErrors);
    }
  }
}
