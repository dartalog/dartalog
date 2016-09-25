class ForbiddenException implements Exception {
  String message = "Forbidden";

  ForbiddenException();
  ForbiddenException.withMessage(this.message);

  String toString() {
    return message;
  }
}
