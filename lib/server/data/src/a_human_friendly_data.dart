import 'a_data.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
export 'a_data.dart';
import 'package:rpc/rpc.dart';
import 'a_uuid_data.dart';
@ApiMessage()
abstract class AHumanFriendlyData extends AUuidData {
  String name = "";
  String readableId = "";

  AHumanFriendlyData();

  AHumanFriendlyData.withValues(this.name, this.readableId, {String uuid: ""}): super.withValues(uuid);

  AHumanFriendlyData.copy(dynamic o): super.copy(o) {
    this.name = o.name;
    this.readableId = o.readableId;
  }

}
