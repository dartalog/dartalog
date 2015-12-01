part of api;

class FieldResource {
  static final Logger _log = new Logger('FieldResource');

  @ApiMethod(path: 'fields/')
  Future<Map<String,Field>> getAll() async {
    try {
      dynamic output = await Model.fields.getAll();
      return output;
    } catch(e,st) {
     _log.severe(e,st);
      throw e;
    }
  }

  @ApiMethod(path: 'fields/{uuid}/')
  Future<Field> get(String uuid) async {
    try {
    dynamic output = await Model.fields.getByUUID(uuid);
    return output;
    } catch(e,st) {
      _log.severe(e,st);
      throw e;
    }
  }

  @ApiMethod(method: 'POST', path: 'fields/')
  Future<VoidMessage> create(Field field) async {
    try {
      await Model.fields.write(field);
      //return new UuidResponse.fromUuid(output);
    } catch(e,st) {
    _log.severe(e,st);
    throw e;
    }
  }

  @ApiMethod(method: 'PUT', path: 'fields/{uuid}/')
  Future<VoidMessage> update(String uuid, Field field) async {
    try {
    String output = await Model.fields.write(field,uuid);
    return new UuidResponse.fromUuid(output);
    } catch(e,st) {
      _log.severe(e,st);
      throw e;
    }
  }

}