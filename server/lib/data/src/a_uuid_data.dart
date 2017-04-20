import 'a_data.dart';

class AUuidData extends AData {
  String uuid = "";

  AUuidData();

  AUuidData.withValues(this.uuid);

  AUuidData.copy(dynamic o) {
    this.uuid = o.uuid;
  }
}
