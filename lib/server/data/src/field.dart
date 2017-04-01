import 'package:rpc/rpc.dart';

import 'a_human_friendly_data.dart';
import 'a_templating_data.dart';
@ApiMessage(includeSuper: true)
class Field extends AHumanFriendlyData {
  bool unique = false;

  String type;
  String format = "";

  Field();

  Field.copy(dynamic from) {
    copyObject(from, this);
  }

  Field.withValues(String name, String readableId, this.type,
      {this.unique: false, this.format: "", String uuid: ""})
      : super.withValues(name, readableId, uuid: uuid);

  void copyObject(dynamic from, dynamic to) {
    to.format = from.format;
    to.uuid = from.uuid;
    to.name = from.name;
    to.type = from.type;
    to.unique = from.unique;
  }
}
