part of api;

class CreateItemRequest {
  Item item;
  List<MediaMessage> files = new List<MediaMessage>();

  String collectionId;
  String uniqueId;


  CreateItemRequest();
}
