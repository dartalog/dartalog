import 'package:dartalog/data/src/a_id_data.dart';

class IdNamePair extends AIdData {
  String id = "";
  String name = "";
  IdNamePair();

  IdNamePair.copy(dynamic o) {
    this.id = o.getId;
    this.name = o.getName;
  }
  IdNamePair.from(this.id, this.name);
  @override
  String get getId => id;

  @override
  String get getName => name;

  @override
  set setId(String value) => id = value;

  @override
  set setName(String value) => name = value;

  static List<IdNamePair> convertList(Iterable<dynamic> i) {
    final List<IdNamePair> output = new List<IdNamePair>();
    for (dynamic o in i) {
      output.add(new IdNamePair.copy(o));
    }
    return output;
  }
}
