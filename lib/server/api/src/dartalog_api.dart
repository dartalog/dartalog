part of api;

@ApiClass(version: '0.1', name: 'dartalog', description: 'Dartalog REST API')
class DartalogApi {

    DartalogApi();

    @ApiResource()
    final FieldResource fields = new FieldResource();

    @ApiResource()
    final TemplateResource templates = new TemplateResource();

}