class AlreadyExistsException implements Exception {
  String message;
  AlreadyExistsException(this.message);

  @override
  String toString() {
    return message;
  }
}
