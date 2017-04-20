import 'dart:io';

class ForbiddenException implements Exception {
  String message = "Forbidden";

  int code = HttpStatus.UNAUTHORIZED;

  ForbiddenException({this.code: HttpStatus.UNAUTHORIZED});
  ForbiddenException.withMessage(this.message,
      {this.code: HttpStatus.UNAUTHORIZED});

  @override
  String toString() {
    return message;
  }
}
