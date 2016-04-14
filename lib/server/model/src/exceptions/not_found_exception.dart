part of model;

class NotFoundException implements Exception {
  String message;
  NotFoundException(this.message);
  String toString() {
    return message;
  }

}

