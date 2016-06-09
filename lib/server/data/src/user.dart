part of data;

class User extends AIdData {
  String id = "";
  String get getId => id;
  set getId(String value) => id = value;

  String name = "";
  String get getName => name;
  set getName(String value) => name = value;

  String password;

  String idNumber = ""; // For library cards and such

  List<String> privileges = new List<String>();

  User();
}
