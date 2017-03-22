import 'a_id_data.dart';

import 'field.dart';

class ItemType extends AIdData {
  String id = "";
  String name = "";
  String readableId = "";

  List<String> fieldIds = new List<String>();

  List<Field> fields;
  ItemType();
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
