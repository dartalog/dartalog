import 'dart:async';

class TransferException implements Exception {
  String message;
  Map<String, String> transferErrors = new Map<String, String>();
  TransferException(this.message);
  TransferException.WithItemActionErrors(this.message, this.transferErrors);

  @override
  String toString() {
    return message;
  }

  static Future<Null> performValidation(
      Future<Null> toAwait(Map<String, String> transferErrors)) async {
    final Map<String, String> transferErrors = new Map<String, String>();

    await toAwait(transferErrors);

    final Map<String, String> output = <String, String>{};

    for (String id in transferErrors.keys) {
      output[id.toString()] = transferErrors[id];
    }

    if (transferErrors.length > 0) {
      throw new TransferException.WithItemActionErrors(
          "Transfer error", transferErrors);
    }
  }
}
