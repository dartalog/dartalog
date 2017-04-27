import 'a_human_friendly_data.dart';
import 'item_copy.dart';
import 'item_type.dart';
import 'package:option/option.dart';
import 'tag.dart';
import 'package:rpc/rpc.dart';

@ApiMessage(includeSuper: true)
class Item extends AHumanFriendlyData {
  String typeUuid;

  DateTime dateAdded;
  DateTime dateUpdated;

  String file;
  String fileThumbnail;

  Map<String, String> values = new Map<String, String>();

  List<ItemCopy> copies;
  ItemType type;

  List<Tag> tags;

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
