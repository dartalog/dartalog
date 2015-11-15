part of api;

class TemplateResource {
  static final Logger _log = new Logger('TemplateResource');

  @ApiMethod(path: 'templates/')
  Future<Map<String,Template>> getAll() async {
    try {
      Map<String,Template> output = await TemplateModel.getAll();
      return output;
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(path: 'templates/{uuid}/')
  Future<Template> get(String uuid) async {
    try {
      Template output = await TemplateModel.getByUUID(uuid);
      return output;
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(method: 'POST', path: 'templates/')
  Future<UuidResponse> create(Template template) async {
    try {
      String output = await TemplateModel.write(template);
      return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }

  @ApiMethod(method: 'PUT', path: 'templates/{uuid}/')
  Future<UuidResponse> update(String uuid, Template template) async {
    try {
      String output = await TemplateModel.write(template, uuid);
      return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _log.severe(e, st);
      throw e;
    }
  }
}