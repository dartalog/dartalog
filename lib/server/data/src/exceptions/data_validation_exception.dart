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

  static Future<Null> PerformValidation(
      Future toAwait(Map<String, String> field_errors)) async {
    Map<String, String> field_errors = new Map<String, String>();

    await toAwait(field_errors);

    if (field_errors.length > 0) {
      throw new DataValidationException.WithFieldErrors(
          "Invalid data", field_errors);
    }
  }
}
