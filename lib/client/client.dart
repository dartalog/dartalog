library client;

void handleException(dynamic e) {
  if(e is ValidationException) {

  }
}

class ValidationException implements  Exception {
  String message;
  ValidationException(this.message);
}