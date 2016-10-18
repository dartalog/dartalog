import 'item_status.dart';

class ItemAction {
  static const String borrow = "borrow";
  static const String lose = "lose";
  static const String remove = "remove";
  static const String returnItem = "return";

  static final Map<String, ItemAction> availableActions = <String, ItemAction>{
    borrow: new ItemAction(
        borrow, "Borrow", <String>[ItemStatus.available], ItemStatus.borrowed),
    returnItem: new ItemAction(returnItem, "Return",
        <String>[ItemStatus.borrowed], ItemStatus.available),
    remove: new ItemAction(
        remove, "Remove", <String>[ItemStatus.available], ItemStatus.removed),
    lose: new ItemAction(lose, "Mark As Lost",
        <String>[ItemStatus.available, ItemStatus.borrowed], ItemStatus.lost)
  };

  static bool isValidAction(String action) =>
      availableActions.containsKey(action);

  static bool isActionValidForStatus(String action, String status) =>
      availableActions[action].validStatuses.contains(status);

  static String getResultingStatus(String action) =>
      availableActions[action].resultingStatus;

  static List<String> getEligibleActions(String status) {
    final List<String> output = <String>[];
    for (String action in availableActions.keys) {
      if (availableActions[action].validStatuses.contains(status))
        output.add(action);
    }
    return output;
  }

  String id;

  String name;

  List<String> validStatuses;

  String resultingStatus;

  ItemAction(this.id, this.name, this.validStatuses, this.resultingStatus);
}
