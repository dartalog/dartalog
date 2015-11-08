part of model;

class DBRef {
  final mongo.ObjectId id;
  final String collection;

  DBRef(String id) {
    this.id = mongo.ObjectId.parse(id);
  }

  Map toModel() {
    Map output = new Map();
    output["\$id"] = this.id;
    output["\$collection"] = this.collection;
    return output;
  }
}