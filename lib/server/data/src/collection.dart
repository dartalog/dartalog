import 'a_id_data.dart';

class Collection extends AIdData {
  String id = "";
  String name = "";
  String readableId = "";

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

  @override
  String get getReadableId => readableId;
  @override
  set setReadableId(String value) => readableId = value;

}
