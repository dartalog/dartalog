class InvalidInputException implements Exception {
  String message;
  InvalidInputException(this.message);

  @override
  String toString() {
    return message;
  }
}
