import 'package:dartalog/data/src/a_id_data.dart';

class Collection extends AIdData {
  String id = "";
  String name = "";
  bool publiclyBrowsable = false;

  List<String> curators = <String>[];
  List<String> browsers = <String>[];
  Collection();

  @override
  String get getId => id;

  @override
  String get getName => name;
  @override
  set setId(String value) => id = value;

  @override
  set setName(String value) => name = value;
}
