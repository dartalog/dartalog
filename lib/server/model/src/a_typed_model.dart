part of model;

abstract class ATypedModel<T> extends AModel {
  Future validate(T t, bool creating) =>
      DataValidationException.PerformValidation((Map output) async =>
          output.addAll(await _validateFields(t, creating)));

  Future<Map<String, String>> _validateFields(T t, bool creating);
}
