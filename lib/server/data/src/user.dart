import 'a_id_data.dart';

class User extends AIdData {
  String id = "";
  String get getId => id;
  set getId(String value) => id = value;

  String name = "";
  String get getName => name;
  set getName(String value) => name = value;

  String password;

  String idNumber = ""; // For library cards and such

  String type;

  User();
}
