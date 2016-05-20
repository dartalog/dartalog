part of api;

class FieldResource extends AResource {
  static final Logger _log = new Logger('FieldResource');

  Logger _GetLogger() {
    return _log;
  }

  @ApiMethod(path: 'fields/')
  Future<List<Field>> getAll() async {
    try {
      List<Field> output = await model.fields.getAll();
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: 'fields/{id}/')
  Future<Field> get(String id) async {
    try {
      Field output = await model.fields.get(id);
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'POST', path: 'fields/')
  Future<VoidMessage> create(Field field) async {
    try {
      await field.validate(true);
      await model.fields.write(field);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: 'fields/{id}/')
  Future<IdResponse> update(String id, Field field) async {
    try {
      await field.validate(id!=field.id);
      String output = await model.fields.write(field, id);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }


  void _HandleException(e, st) {
    if (e is model.DataMovedException) {
      model.DataMovedException dme = e as model.DataMovedException;
      sendRedirect("http://localhost:8888/fields/${dme.newId}");
    } else {
      super._HandleException(e, st);
    }
  }
}