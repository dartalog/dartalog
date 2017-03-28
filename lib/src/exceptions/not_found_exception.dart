class NotFoundException implements Exception {
  String message;
  NotFoundException(this.message);
  @override
  String toString() {
    return message;
  }
}
