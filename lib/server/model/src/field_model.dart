part of model;

class FieldModel extends AIdNameBasedModel<Field> {
  static final Logger _log = new Logger('FieldModel');
  Logger get _logger => _log;
  data_sources.AIdNameBasedDataSource<Field> get dataSource => data_sources.fields;

  @override
  Future<Map<String, String>> _validateFieldsInternal(Field field) async {
    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(field.type))
      field_errors["type"] = "Required";
    else if(!FIELD_TYPES.containsKey(field.type)) {
      field_errors["type"] = "Invalid";
    }

    if (!isNullOrWhitespace(field.format)) {
      String test = validateRegularExpression(field.format);
      if (!isNullOrWhitespace(test)) field_errors["format"] = test;
    }

    return field_errors;
  }

}