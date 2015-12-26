part of api;

class TemplateResource {
  static final Logger _log = new Logger('TemplateResource');

  @ApiMethod(path: 'templates/')
  Future<Map<String,Template>> getAll() async {
    try {
      Map<String,Template> output = await Model.templates.getAll();
      return output;
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(path: 'templates/{uuid}/')
  Future<TemplateResponse> get(String uuid) async {
    try {
      TemplateResponse output = new TemplateResponse();
      output.template = await Model.templates.get(uuid);
      output.fields = await Model.fields.getAllForIDs(output.template.fields);
      return output;
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(method: 'POST', path: 'templates/')
  Future<VoidMessage> create(Template template) async {
    try {
      template.validate();
      await Model.templates.write(template);
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(method: 'PUT', path: 'templates/{uuid}/')
  Future<VoidMessage> update(String uuid, Template template) async {
    try {
      template.validate();
      String output = await Model.templates.write(template, uuid);
      //return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }
}