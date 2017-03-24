import 'a_id_data.dart';

import 'package:rpc/rpc.dart';
@ApiMessage(includeSuper: true)
class Field extends AIdData {

  bool unique = false;

  String type;
  String format = "";
  Field();

  Field.copy(dynamic from) {
    copyObject(from, this);
  }

  Field.withValues(String id, String name, String readableId, this.type,
      {this.unique: false, this.format: ""}): super.withValues(id,name, readableId);


  void copyObject(dynamic from, dynamic to) {
    to.format = from.format;
    to.id = from.id;
    to.name = from.name;
    to.type = from.type;
    to.unique = from.unique;
  }
}
