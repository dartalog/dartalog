import 'a_id_data.dart';

class IdNamePair extends AIdData {
  String id = "";
  String name = "";
  String readableId = "";

  IdNamePair();

  IdNamePair.copy(dynamic o) {
    this.id = o.id;
    this.name = o.name;
    this.readableId = o.readableId;
  }

  IdNamePair.from(this.id, this.name, {this.readableId});

  @override
  String get getId => id;

  @override
  String get getName => name;

  @override
  String get getReadableId => readableId;

  @override
  set setId(String value) => id = value;

  @override
  set setName(String value) => name = value;

  @override
  set setReadableId(String value) => readableId = value;
  static List<IdNamePair> convertList(Iterable<dynamic> i) {
    final List<IdNamePair> output = new List<IdNamePair>();
    for (dynamic o in i) {
      output.add(new IdNamePair.copy(o));
    }
    return output;
  }

  static List<IdNamePair> copyList(Iterable<dynamic> i) {
    final List<IdNamePair> output = new List<IdNamePair>();
    for (dynamic o in i) {
      output.add(new IdNamePair.copy(o));
    }
    return output;
  }
}
