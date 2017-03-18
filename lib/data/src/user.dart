import 'a_id_data.dart';
import 'package:dartalog/global.dart';

class User extends AIdData {
  String id = "";
  String name = "";
  String password;

  String idNumber = "";
  String type;
  User();

  User.copy(dynamic field) {
    _copy(field, this);
  }

  @override
  String get getId => id; // For library cards and such

  @override
  set setId(String value) => id = value;

  @override
  String get getName => name;

  @override
  set setName(String value) => name = value;

  void copyTo(dynamic to) {
    _copy(this, to);
  }

  bool evaluateType(String needed) {
    return UserPrivilege.evaluate(needed, this.type);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.type = from.type;
    if (from.password == null)
      to.password = "";
    else
      to.password = from.password;
  }

  static List<User> copyList(Iterable<dynamic> e) {
    final List<User> output = <User>[];
    for (dynamic obj in e) {
      output.add(new User.copy(obj));
    }
    return output;
  }
}
