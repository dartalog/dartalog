part of api;

class FullItemResponse {
  Item data;
  Template template;
  Map<String,Field> fields = new Map<String,Field>();

  FullItemResponse();
}