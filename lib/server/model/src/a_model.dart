part of model;

abstract class AModel<T> {
  Logger get _logger;

  String getUserId() =>
      getUserPrincipal().map((Principal p) => p.name).getOrDefault("");

  Option<Principal> getUserPrincipal() => authenticatedContext()
      .map((AuthenticatedContext context) => context.principal);

  bool userAuthenticated() =>
      getUserPrincipal().map((Principal p) => true).getOrDefault(false);

  Future validate(T t, bool creating) =>
      DataValidationException.PerformValidation(() { return _validateFields(t, creating);} );

  Future<Map<String, String>> _validateFields(T t, bool creating);
}
