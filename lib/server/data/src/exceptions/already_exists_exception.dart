part of data;

class AlreadyExistsException implements  Exception {
  String message;
  AlreadyExistsException(this.message);

  String toString() {
    return message;
  }
}

