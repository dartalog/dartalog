import '../a_parented_uuid_data.dart';

abstract class AHistoryEntry extends AParentedUuidData {
  final String entryType;

  String itemUuid = "";
  String itemCopyUuid = "";

  @override
  String get parentUuid => itemCopyUuid;

  String operatorUserUuid = "";

  DateTime timestamp = new DateTime.now();

  AHistoryEntry(this.entryType);
}
