part of data;

class DataValidationException implements  Exception {
  String message;
  Map<String,String> fieldErrors = new Map<String,String>();
  DataValidationException(this.message);
  DataValidationException.WithFieldErrors(this.message, this.fieldErrors);

  String toString() {
    return message;
  }

  static Future PerformValidation(Future<Map<String,String>> toAwait) async {
    Map<String,String> field_errors = await toAwait;

    if (field_errors.length > 0) {
      throw new DataValidationException.WithFieldErrors(
          "Invalid data", field_errors);
    }
  }

}

