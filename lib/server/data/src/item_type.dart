import 'a_id_data.dart';

import 'field.dart';
import 'package:rpc/rpc.dart';
@ApiMessage(includeSuper: true)
class ItemType extends AIdData {
  List<String> fieldIds = new List<String>();

  List<Field> fields;

  ItemType();
}
