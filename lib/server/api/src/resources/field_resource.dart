part of api;

class FieldResource {
  FieldModel model = new FieldModel();

  @ApiMethod(path: 'fields/')
  Future<List<Field>> getAll() async {
      List<Field> output =await model.getAll();
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