part of api;

class FieldResource {
  static final Logger _log = new Logger('FieldResource');

  FieldModel model = new FieldModel();

  @ApiMethod(path: 'fields/')
  Future<List<Field>> getAll() async {
    try {
      List<Field> output = await model.getAll();
      return output;
    } catch(e,st) {
     _log.severe(e,st);
      throw e;
    }
  }

  @ApiMethod(path: 'fields/{uuid}/')
  Future<Field> get(String uuid) async {
    Field output = await model.getByUUID(uuid);
    return output;
  }

  @ApiMethod(method: 'POST', path: 'fields/')
  Future<UuidResponse> create(Field field) async {
      String output = await model.write(field);
      return new UuidResponse.fromUuid(output);
  }

  @ApiMethod(method: 'PUT', path: 'fields/{uuid}/')
  Future<UuidResponse> update(String uuid, Field field) async {
    String output = await model.write(field,uuid);
    return new UuidResponse.fromUuid(output);
  }

}