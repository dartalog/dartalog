part of api;

class ItemType extends AIdData {
  @ApiProperty(required: true)
  List<String> fieldIds = new List<String>();

  List<Field> fields = null;

  ItemType();

  Future _getById(String id) => model.itemTypes.getById(id);

  Future _validateFieldsInternal() async {
    Map<String, String> field_errors = new Map<String, String>();

    if (this.fieldIds == null || this.fieldIds.length == 0)
      field_errors["fieldIds"] = "Required";
    else {
      List test = await model.fields.getByIds(this.fieldIds);
      if(test.length==this.fieldIds.length)
        field_errors["fieldIds"] = "Not found";
    }

    return field_errors;
  }
}
