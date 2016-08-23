class InvalidInputException implements Exception {
  String message;
  InvalidInputException(this.message);

  String toString() {
    return message;
  }
}
