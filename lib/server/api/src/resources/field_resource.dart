part of api;

class FieldResource {
  FieldModel model = new FieldModel();

  @ApiMethod(path: 'fields/')
  Future<List<Field>> getAll() async {
      List<Field> output =await model.getAll();
      return output;
  }

  @ApiMethod(method: 'POST', path: 'fields/')
  Future<String> create(Field field) async {
    String output = await model.write(field);
    return output;
  }

  @ApiMethod(method: 'PUT', path: 'fields/{uuid}/')
  Future<String> update(String uuid, Field field) async {
    String output = await model.write(field,uuid);
    return output;
  }

}