part of data;

class ItemType extends AIdData {
  String id = "";
  String get getId => id;
  set getId(String value) => id = value;

  String name = "";
  String get getName => name;
  set getName(String value) => name = value;

  List<String> fieldIds = new List<String>();

  List<Field> fields = null;

  ItemType();

}
