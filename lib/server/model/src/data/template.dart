part of model;

class Template extends AData {
  @ApiProperty(required: true)
  String name;

  @ApiProperty(required: true)
  List<String> fields = new List<String>();

  Template();

  Template.fromData(dynamic data) {
    this.name = data["name"];
    for(mongo.DbRef field_ref in data["fields"]) {
      this.fields.add(field_ref.id.toJson());
    }

  }

  void setData(dynamic data) {
    data["name"] = this.name;

    List<mongo.DbRef> field_ids = new List<mongo.DbRef>();
    for(String field_string in fields) {
      field_ids.add(new mongo.DbRef(TemplateModel.TEMPLATES_COLLECTION,mongo.ObjectId.parse(field_string)));
    }

    data["fields"] = field_ids;
  }
}