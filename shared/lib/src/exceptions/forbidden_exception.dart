import 'dart:io';

class ForbiddenException implements Exception {
  String message = "Forbidden";

  int code = HttpStatus.FORBIDDEN;

  ForbiddenException({this.code: HttpStatus.FORBIDDEN});
  ForbiddenException.withMessage(this.message,
      {this.code: HttpStatus.FORBIDDEN});

  @override
  String toString() {
    return message;
  }
}
