import 'package:dartalog/server/data/data.dart';

class BulkItemActionRequest {
  String action;
  String actionerUserId;
  List<ItemCopyId> itemCopies;

  BulkItemActionRequest();
}
