import 'package:polymer/polymer.dart';
import 'package:dartalog/global.dart';

class User extends JsProxy {
  @property
  String id;
  @property
  String name;

  @reflectable
  String type;

  @reflectable
  String password = "";
  @reflectable
  String confirmPassword = "";
  @reflectable
  String currentPassword = "";

  User();

  User.copy(dynamic field) {
    _copy(field, this);
  }

  void copyTo(dynamic to) {
    _copy(this, to);
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

  bool evaluateType(String needed) {
    return UserPrivilege.evaluate(needed, this.type);
  }
}
