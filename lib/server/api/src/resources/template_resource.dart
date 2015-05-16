part of api;

class TemplateResource {
  TemplateModel model = new TemplateModel();

  @ApiMethod(path: 'templates/')
  Future<List<Template>> getAll() async {
      List<Template> output = await model.getAll();
      return output;
  }

}