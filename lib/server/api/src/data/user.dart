part of api;

class User extends AIdData {
  @ApiProperty(required: false)
  String id = "";
  String get _id => id;
  set _id(String value) => id = value;

  @override
  @ApiProperty(required: true)
  String name = "";
  String get _name => name;
  set _name(String value) => name = value;

  @ApiProperty(required: true)
  String password;

  User();

  Future _getById(String id) => model.users.getById(id);

  void cleanUp() {

  }

  bool verifyPassword(String input) => new crypt.Crypt(this.password).match(input);
}
