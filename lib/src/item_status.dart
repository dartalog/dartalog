import 'package:intl/intl.dart';
import '../tools.dart';

abstract class ItemStatus {
  static const String defaultStatus = available;

  static const String borrowed = 'borrowed';
  static const String available = 'available';
  static const String lost = 'lost';
  static const String removed = 'removed';

  static final List<String> _validStatuses = <String>[
    borrowed,
    available,
    lost,
    removed
  ];

  static bool isValidStatus(String status) => _validStatuses.contains(status);

  static String borrowedName() => Intl.message("Borrowed",
      name: "ItemStatus_borrowedName",
      args: <String>[],
      desc: "The display name for the borrowed status");
  static String availableName() => Intl.message("Available",
      name: "ItemStatus_availableName",
      args: <String>[],
      desc: "The display name for the available status");
  static String lostName() => Intl.message("Lost",
      name: "ItemStatus_lostName",
      args: <String>[],
      desc: "The display name for the lost status");
  static String removedName() => Intl.message("Removed",
      name: "ItemStatus_removedName",
      args: <String>[],
      desc: "The display name for the removed status");

  static String getDisplayName(String status) {
    switch (status) {
      case available:
        return availableName();
      case borrowed:
        return borrowedName();
      case lost:
        return lostName();
      case removed:
        return removedName();
    }
    return StringTools.empty;
  }
}
