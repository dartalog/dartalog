class ForbiddenException implements Exception {
  String message = "Forbidden";

  ForbiddenException();
  ForbiddenException.withMessage(this.message);

  @override
  String toString() {
    return message;
  }
}
