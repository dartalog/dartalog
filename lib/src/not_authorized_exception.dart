part of dartalog;

class NotAuthorizedException implements  Exception {
  String message = "Not authorized";

  int code = 401;

  NotAuthorizedException({this.code: 401});
  NotAuthorizedException.withMessage(this.message, {this.code: 401});

  String toString() {
    return message;
  }

}

