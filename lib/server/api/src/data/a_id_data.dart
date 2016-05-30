part of api;

abstract class AIdData extends AData{
  String get _id;
  set _id(String value);
  String get _name;
  set _name(String value);

  void cleanUp() {
    this._id = this._id.trim().toLowerCase();
    this._name = this._name.trim();
    _cleanUpInternal();
  }

  void _cleanUpInternal() {}

  Future _validateFields(bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(this._id))
      field_errors["id"] = "Required";
    else {
      if (creating) {
        dynamic other = await _getById(this._id);
        if (other != null) field_errors["id"] = "Already in use";
      }
      if (RESERVED_WORDS.contains(this._id.trim().toLowerCase())) {
        field_errors["id"] = "Cannot use '${this._id}' as ID";
      }
    }

    if (isNullOrWhitespace(this._name)) {
      field_errors["name"] = "Required";
    } else if (RESERVED_WORDS.contains(this._id.trim().toLowerCase())) {
      field_errors["name"] = "Cannot use '${this._name}' as name";
    }

    field_errors.addAll(await _validateFieldsInternal());

    return field_errors;
  }

  Future _getById(String id);

  Future<Map<String, String>> _validateFieldsInternal() async => {};

}
