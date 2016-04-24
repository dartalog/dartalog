part of api;

class FieldResource extends AResource {
  static final Logger _log = new Logger('FieldResource');

  Logger _GetLogger() {
    return _log;
  }

  @ApiMethod(path: 'fields/')
  Future<Map<String, Field>> getAll() async {
    try {
      dynamic output = await model.fields.getAll();
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: 'fields/{uuid}/')
  Future<Field> get(String uuid) async {
    try {
      dynamic output = await model.fields.get(uuid);
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'POST', path: 'fields/')
  Future<VoidMessage> create(Field field) async {
    try {
      field.validate();
      await model.fields.write(field);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: 'fields/{uuid}/')
  Future<UuidResponse> update(String uuid, Field field) async {
    try {
      field.validate();
      String output = await model.fields.write(field, uuid);
      return new UuidResponse.fromUuid(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

}