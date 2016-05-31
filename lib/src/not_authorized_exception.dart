part of dartalog;

class NotAuthorizedException implements  Exception {
  String message = "Not authorized";

  NotAuthorizedException();
  NotAuthorizedException.withMessage(this.message);

  String toString() {
    return message;
  }

}

