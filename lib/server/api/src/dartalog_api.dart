part of api;

@ApiClass(version: '0.1', name: 'dartalog', description: 'Dartalog REST API')
class DartalogApi {

    DartalogApi();

    @ApiResource()
    final FieldResource fields = new FieldResource();

    @ApiResource()
    final ItemTypeResource templates = new ItemTypeResource();

    @ApiResource()
    final ItemResource items = new ItemResource();

    @ApiResource()
    final ImportResource import = new ImportResource();
}