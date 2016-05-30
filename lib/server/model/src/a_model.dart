part of model;

abstract class AModel<T> {
  Logger get _logger;

  Future validate(T t, bool creating) async {
    DataValidationException.PerformValidation(_validateFields(t, creating));
 }

  Future<Map<String, String>> _validateFields(T t, bool creating);

}