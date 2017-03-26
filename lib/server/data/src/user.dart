import 'package:dartalog/global.dart';
import 'package:rpc/rpc.dart';

import 'a_human_friendly_data.dart';

@ApiMessage(includeSuper: true)
class User extends AHumanFriendlyData {
  String password;

  String type;
  User();
  User.copy(dynamic field) {
    _copy(field, this);
  }

  void copyTo(dynamic to) {
    _copy(this, to);
  }

  bool evaluateType(String needed) {
    return UserPrivilege.evaluate(needed, this.type);
  }

  void _copy(dynamic from, dynamic to) {
    to.uuid = from.uuid;
    to.name = from.name;
    to.readableId = from.readableId;
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
