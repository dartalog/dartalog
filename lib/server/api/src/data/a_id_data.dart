part of api;

abstract class AIdData extends AData{
  @ApiProperty(required: false)
  String id = "";

  @ApiProperty(required: true)
  String name = "";

  void cleanUp() {
    this.id = this.id.trim().toLowerCase();
    this.name = this.name.trim();
    _cleanUpInternal();
  }

  void _cleanUpInternal() {}

  Future _validateFields(bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(this.id))
      field_errors["id"] = "Required";
    else {
      if (creating) {
        dynamic other = await _getById(this.id);
        if (other != null) field_errors["id"] = "Already in use";
      }
      if (RESERVED_WORDS.contains(this.id.trim().toLowerCase())) {
        field_errors["id"] = "Cannot use '${this.id}' as ID";
      }
    }

    if (isNullOrWhitespace(this.name)) {
      field_errors["name"] = "Required";
    } else if (RESERVED_WORDS.contains(this.id.trim().toLowerCase())) {
      field_errors["name"] = "Cannot use '${this.name}' as name";
    }

    field_errors.addAll(await _validateFieldsInternal());

    return field_errors;
  }

  Future _getById(String id);

  Future<Map<String, String>> _validateFieldsInternal() {}

}
