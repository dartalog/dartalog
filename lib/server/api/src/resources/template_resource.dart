part of api;

class TemplateResource {
  static final Logger _log = new Logger('TemplateResource');

  TemplateModel model = new TemplateModel();

  @ApiMethod(path: 'templates/')
  Future<Map<String,Template>> getAll() async {
    try {
      Map<String,Template> output = await model.getAll();
      return output;
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(path: 'templates/{uuid}/')
  Future<Template> get(String uuid) async {
    try {
      Template output = await model.getByUUID(uuid);
      return output;
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(method: 'POST', path: 'templates/')
  Future<UuidResponse> create(Template template) async {
    try {
      String output = await model.write(template);
      return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(method: 'PUT', path: 'templates/{uuid}/')
  Future<UuidResponse> update(String uuid, Template template) async {
    try {
      String output = await model.write(template, uuid);
      return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }
}