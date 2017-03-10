import 'package:dartalog/data/src/a_id_data.dart';

class IdNamePair extends AIdData {
  String id = "";
  String get getId => id;
  set getId(String value) => id = value;

  String name = "";
  String get getName => name;
  set getName(String value) => name = value;

  IdNamePair();

  IdNamePair.copy(dynamic o) {
    this.id = o.getId;
    this.name = o.getName;
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
