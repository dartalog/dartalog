import 'a_id_data.dart';

class Field extends AIdData {
  String id = "";
  String get getId => id;
  set getId(String value) => id = value;

  String name = "";
  String get getName => name;
  set getName(String value) => name = value;

  bool unique = false;

  String type;

  String format = "";

  Field();
}
