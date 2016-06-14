part of data;

class User extends JsProxy {
  @property String id;
  @property String name;

  @property List<String> privileges = [];

  @reflectable
  String password = "";
  @reflectable
  String confirmPassword = "";
  @reflectable
  String currentPassword = "";


  User();

  User.copy(dynamic field) {
    _copy(field,this);
  }

  void copyTo(dynamic to) {
    _copy(this,to);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.privileges = from.privileges;
    if(from.password==null)
      to.password = "";
    else
      to.password = from.password;
  }

  static List<User> copyList(Iterable e) {
    List output = [];
    for(dynamic obj in e) {
      output.add(new User.copy(obj));
    }
    return output;
  }
}