part of api;

class UpdateItemRequest {
  Item item;
  List<MediaMessage> files = new List<MediaMessage>();

  UpdateItemRequest();
}
