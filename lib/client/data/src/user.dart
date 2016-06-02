part of data;

class User extends JsProxy {
  @property String id;
  @property String name;

  User.copy(dynamic field) {
    _copy(field,this);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
  }
}