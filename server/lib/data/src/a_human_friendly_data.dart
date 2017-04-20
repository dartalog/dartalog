export 'package:dartalog/data/src/a_data.dart';
import 'package:rpc/rpc.dart';
import 'package:dartalog/data/src/a_uuid_data.dart';

@ApiMessage(includeSuper: true)
abstract class AHumanFriendlyData extends AUuidData {
  String name = "";
  String readableId = "";

  AHumanFriendlyData();

  AHumanFriendlyData.withValues(this.name, this.readableId, {String uuid: ""})
      : super.withValues(uuid);

  AHumanFriendlyData.copy(dynamic o) : super.copy(o) {
    this.name = o.name;
    this.readableId = o.readableId;
  }
}
