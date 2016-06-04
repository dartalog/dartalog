part of api;

class BulkItemActionRequest {
  String action;
  String actionerUserId;
  List<ItemCopyId> itemCopies;

  BulkItemActionRequest();
}
