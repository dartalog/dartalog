abstract class AHistoryEntry {
  final String entryType;
  String itemId = "";
  int copy = 0;
  String operatorUserId = "";
  DateTime timestamp = new DateTime.now();

  AHistoryEntry(this.entryType);

}
