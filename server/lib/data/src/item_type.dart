import 'a_human_friendly_data.dart';

import 'field.dart';
import 'package:rpc/rpc.dart';

@ApiMessage(includeSuper: true)
class ItemType extends AHumanFriendlyData {
  List<String> fieldUuids = new List<String>();

  bool isFileType = false;

  List<Field> fields;

  ItemType();

  ItemType.withValues(String name, String readableId, this.fieldUuids,
      {String uuid: ""})
      : super.withValues(name, readableId, uuid: uuid);
}
