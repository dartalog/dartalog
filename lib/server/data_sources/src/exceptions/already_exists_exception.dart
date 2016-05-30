part of data_sources;

class AlreadyExistsException implements  Exception {
  String message;
  AlreadyExistsException(this.message);

  String toString() {
    return message;
  }
}

