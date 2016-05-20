part of model;

class DataMovedException implements Exception {
  final String oldId, newId;
  DataMovedException(this.oldId, this.newId);
}

