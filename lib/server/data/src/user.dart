import 'package:dartalog/global.dart';
import 'package:rpc/rpc.dart';

import 'a_id_data.dart';

@ApiMessage(includeSuper: true)
class User extends AIdData {
  String _id = "";
  String name = "";

  String password;
  String idNumber = "";

  String type;
  User();
  User.copy(dynamic field) {
    _copy(field, this);
  }

  @override
  String get getId => id;

  @override
  String get getName => name; // For library cards and such

  String get id => _id;

  @override
  set setId(String value) => id = value;

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
