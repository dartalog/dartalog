import 'package:polymer/polymer.dart';

class IdNamePair extends JsProxy {
  @reflectable
  String id = "";

  @reflectable
  String name = "";

  IdNamePair(this.id, this.name);

  IdNamePair.copy(dynamic o) {
    this.id = o.id;
    this.name = o.name;
  }

  static List<IdNamePair> copyList(Iterable i) {
    List<IdNamePair> output = new List<IdNamePair>();
    for(dynamic o in i) {
      output.add(new IdNamePair.copy(o));
    }
    return output;
  }
}