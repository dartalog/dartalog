import 'dart:io';

class NotAuthorizedException implements Exception {
  String message = "Not authorized";

  int code = 401;

  NotAuthorizedException({this.code: HttpStatus.UNAUTHORIZED});
  NotAuthorizedException.withMessage(this.message,
      {this.code: HttpStatus.UNAUTHORIZED});

  @override
  String toString() {
    return message;
  }
}
