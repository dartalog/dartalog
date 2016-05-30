part of data;

class Item extends AIdData {
  String _id = "";
  String get id => _id;
  set id(String value) => _id = value;

  String _name = "";
  String get name => _name;
  set name(String value) => _name = value;

  String typeId;

  Map<String, String> values = new Map<String, String>();

  List<String> fileUploads = new List<String>();

  int copyCount = 0;

  List<ItemCopy> copies;
  ItemType type;

  Item();

}
