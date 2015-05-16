part of model;

class Template {
  String uuid;
  String name;
  List<String> fields = new List<String>();

  Template();

  Template.fromData(dynamic data) {
    this.uuid = formatUuid(data.uuid);
    this.name = data.name;

  }
}