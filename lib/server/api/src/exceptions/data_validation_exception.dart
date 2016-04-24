part of api;

class DataValidationException implements  Exception {
  String message;
  Map<String,String> fieldErrors = new Map<String,String>();
  DataValidationException(this.message);
  DataValidationException.WithFieldErrors(this.message, this.fieldErrors);

  String toString() {
    return message;
  }

}

