abstract class AHistoryEntry {
  final String entryType;

  String itemUuid = "";
  String itemCopyUuid = "";

  String operatorUserUuid = "";

  DateTime timestamp = new DateTime.now();

  AHistoryEntry(this.entryType);

}
