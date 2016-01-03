part of api;

class ItemResponse {
  Item item;
  ItemType template;
  Map<String,Field> fields = new Map<String,Field>();

  ItemResponse();
}