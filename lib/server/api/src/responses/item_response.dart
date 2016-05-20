part of api;

class ItemResponse {
  Item item;
  ItemType type;
  Map<String,String> values = new Map<String,String>();

  ItemResponse();
}