import 'package:dartalog/data/src/a_id_data.dart';
import 'package:dartalog/data/src/item_copy.dart';
import 'item_type.dart';
import 'package:option/option.dart';

class Item extends AIdData {
  String id = "";
  @override
  String get getId => id;
  @override
  set setId(String value) => id = value;

  String name = "";
  @override
  String get getName => name;
  @override
  set setName(String value) => name = value;

  String typeId;

  DateTime dateAdded;
  DateTime dateUpdated;

  Map<String, String> values = new Map<String, String>();

  List<ItemCopy> copies;
  ItemType type;

  bool canEdit = false;
  bool canDelete = false;

  Item();

//  Option<ItemCopy> getCopy(int copy) {
//    for (ItemCopy itemCopy in this.copies) {
//      if (itemCopy.copy == copy) return new Some(itemCopy);
//    }
//    return new None();
//  }
}
