part of api;

class ItemResponse {
  Item item;
  Template template;
  Map<String,Field> fields = new Map<String,Field>();

  ItemResponse();
}