part of model;

class Template extends AData {
  @ApiProperty(required: true)
  String name;

  @ApiProperty(required: true)
  Map<String,Field> fields = new Map<String,Field>();

  Template();

  Template.fromData(dynamic data, Map<String,Field> fields) {
    this.name = data["name"];
    for(mongo.DbRef field_ref in data["fields"]) {
      this.fields[field_ref.id.toJson()] = fields[field_ref.id.toJson()];
    }

  }


  void setData(dynamic data) {
    data["name"] = this.name;

    List<mongo.DbRef> field_ids = new List<mongo.DbRef>();
    for(String field_string in fields.keys) {
      field_ids.add(new mongo.DbRef(TemplateModel.TEMPLATES_COLLECTION,mongo.ObjectId.parse(field_string)));
    }

    data["fields"] = field_ids;
  }
}