import 'dart:async';

class DataValidationException implements Exception {
  String message;
  Map<String, String> fieldErrors = new Map<String, String>();
  DataValidationException(this.message);
  DataValidationException.WithFieldErrors(this.message, this.fieldErrors);

  @override
  String toString() {
    return message;
  }

  static Future<Null> performValidation(
      Future<Null> toAwait(Map<String, String> fieldErrors)) async {
    final Map<String, String> fieldErrors = new Map<String, String>();

    await toAwait(fieldErrors);

    if (fieldErrors.length > 0) {
      throw new DataValidationException.WithFieldErrors(
          "Invalid data", fieldErrors);
    }
  }
}
