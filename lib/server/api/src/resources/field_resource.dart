part of api;

class FieldResource {
  FieldModel model = new FieldModel();

  @ApiMethod(path: 'fields/')
  Future<List<Field>> getAll() async {
      List<Field> output =await model.getAll();
      return output;
  }

}