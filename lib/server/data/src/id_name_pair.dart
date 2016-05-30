part of data;

class IdNamePair {
  String id = "";
  String name = "";

  IdNamePair();

  IdNamePair.copy(dynamic o) {
    this.id = o.id;
    this.name = o.name;
  }

  IdNamePair.from(this.id, this.name);

  static List<IdNamePair> convertList(Iterable i) {
    List<IdNamePair> output = new List<IdNamePair>();
    for (dynamic o in i) {
      output.add(new IdNamePair.copy(o));
    }
    return output;
  }
}
