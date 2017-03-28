import 'a_parented_uuid_data.dart';
import 'collection.dart';
import 'item_summary.dart';
import 'package:rpc/rpc.dart';

@ApiMessage(includeSuper: true)
class ItemCopy extends AParentedUuidData {
  String itemUuid = "";
  String collectionUuid = "";
  String uniqueId = "";
  String status = "";
  String statusName = "";

  bool userCanCheckout = false;
  bool userCanEdit = false;

  List<String> eligibleActions = [];
  Collection collection;
  ItemSummary itemSummary;

  ItemCopy();

  ItemCopy.copyItem(ItemCopy o) : super.copyItem(o) {
    this.itemUuid = o.itemUuid;
    this.collectionUuid = o.collectionUuid;
    this.collection = o.collection;
    this.uniqueId = o.uniqueId;
    this.status = o.status;
  }

  @override
  String get parentUuid => itemUuid;

  void cleanUp() {
    this.uniqueId = this.uniqueId.trim();
  }

  @override
  String toString() {
    throw new Exception("Don't call this");
  }
}
