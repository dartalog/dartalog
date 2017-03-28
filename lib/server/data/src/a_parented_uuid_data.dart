import 'a_uuid_data.dart';
import 'package:rpc/rpc.dart';

@ApiMessage(includeSuper: true)
abstract class AParentedUuidData extends AUuidData {
  AParentedUuidData();
  AParentedUuidData.copyItem(dynamic o) : super.copy(o);
  String get parentUuid;
}
