import 'package:dartalog/server/data/data.dart';

class BulkItemActionRequest {
  String action;
  String actionerUserUuid;
  List<String> itemCopyUuids;

  BulkItemActionRequest();
}
