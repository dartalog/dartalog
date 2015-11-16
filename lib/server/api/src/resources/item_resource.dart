part of api;

class ItemResource {
  static final Logger _log = new Logger('ItemResource');

  @ApiMethod(path: 'fields/')
  Future<Map<String,Field>> getAll() async {
    try {
      dynamic output = await FieldModel.getAll();
      return output;
    } catch(e,st) {
     _log.severe(e,st);
      throw e;
    }
  }

  @ApiMethod(path: 'fields/{uuid}/')
  Future<Field> get(String uuid) async {
    try {
    dynamic output = await FieldModel.getByUUID(uuid);
    return output;
    } catch(e,st) {
      _log.severe(e,st);
      throw e;
    }
  }

  @ApiMethod(method: 'POST', path: 'fields/')
  Future<UuidResponse> create(Field field) async {
    try {
      String output = await FieldModel.write(field);
      return new UuidResponse.fromUuid(output);
    } catch(e,st) {
    _log.severe(e,st);
    throw e;
    }
  }

  @ApiMethod(method: 'PUT', path: 'fields/{uuid}/')
  Future<UuidResponse> update(String uuid, Field field) async {
    try {
    String output = await FieldModel.write(field,uuid);
    return new UuidResponse.fromUuid(output);
    } catch(e,st) {
      _log.severe(e,st);
      throw e;
    }
  }

}