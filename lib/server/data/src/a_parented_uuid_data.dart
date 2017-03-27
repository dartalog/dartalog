import 'a_uuid_data.dart';

abstract class AParentedUuidData extends AUuidData {
  AParentedUuidData();
  AParentedUuidData.copyItem(dynamic o) : super.copy(o);
  String get parentUuid;
}
