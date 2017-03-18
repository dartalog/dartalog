import 'package:dartalog/data/src/a_id_data.dart';

class Field extends AIdData {
  String id = "";
  String name = "";
  bool unique = false;

  String type;
  String format = "";
  Field();

  @override
  String get getId => id;

  @override
  String get getName => name;

  @override
  set setId(String value) => id = value;

  @override
  set setName(String value) => name = value;
}
