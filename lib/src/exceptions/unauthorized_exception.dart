import 'dart:io';

class UnauthorizedException implements Exception {
  String message = "Not authorized";

  int code = HttpStatus.UNAUTHORIZED;

  UnauthorizedException();
  UnauthorizedException.withMessage(this.message);

  @override
  String toString() {
    return message;
  }
}
