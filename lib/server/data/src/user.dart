import 'package:dartalog/global.dart';
import 'package:rpc/rpc.dart';

import 'a_human_friendly_data.dart';

@ApiMessage(includeSuper: true)
class User extends AHumanFriendlyData {
  String password;

  String type;
  String email;

  User();

  User.copy(dynamic o): super.copy(o) {
    this.email = o.email;
    this.type = o.type;
    if (o.password == null)
      this.password = "";
    else
      this.password = o.password;
  }

  bool evaluateType(String needed) {
    return UserPrivilege.evaluate(needed, this.type);
  }

}
