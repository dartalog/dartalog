part of model;

class AlreadyExistsException implements  Exception {
  String message;
  AlreadyExistsException(this.message);

  String toString() {
    return message;
  }
}

