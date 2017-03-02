import 'a_history_entry.dart';

class TransferHistoryEntry extends AHistoryEntry {
  static const String type = "transfer";

  String fromCollection = "";
  String toCollection = "";

  TransferHistoryEntry(): super(type);
}
