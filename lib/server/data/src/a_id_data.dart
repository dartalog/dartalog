import 'a_data.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
export 'a_data.dart';
import 'package:rpc/rpc.dart';

@ApiMessage()
abstract class AIdData extends AData {
  String id = "";
  String name = "";
  String readableId = "";

  AIdData();

  AIdData.withValues(this.id, this.name, this.readableId);

  AIdData.copy(dynamic o) {
    this.id = o.id;
    this.name = o.name;
    this.readableId = o.readableId;
  }

}
