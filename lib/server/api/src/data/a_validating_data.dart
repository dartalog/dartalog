part of api;

abstract class AValidatingData {
  Future validate(bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    field_errors.addAll(await _validateFields(creating));

    if (field_errors.length > 0) {
      throw new DataValidationException.WithFieldErrors(
          "Invalid data", field_errors);
    }
  }

  Future<Map<String, String>> _validateFields(bool creating);

}
