import 'a_history_entry.dart';

class ActionHistoryEntry extends AHistoryEntry {
  static const String type = "action";

  String action = "";
  String actionerUserUuid = "";

  ActionHistoryEntry(): super(type);
}
