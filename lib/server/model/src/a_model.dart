part of model;

abstract class AModel<T> {
  Logger get _logger;

  String get currentUserId =>
      getUserPrincipal().map((Principal p) => p.name).getOrDefault("");

  Option<Principal> getUserPrincipal() => authenticatedContext()
      .map((AuthenticatedContext context) => context.principal);

  bool userAuthenticated() =>
      getUserPrincipal().map((Principal p) => true).getOrDefault(false);

  Future validate(T t, bool creating) =>
      DataValidationException.PerformValidation((Map output) async => output.addAll(await _validateFields(t, creating)) );

  Future<Map<String, String>> _validateFields(T t, bool creating);

  Future<User> getCurrentUser() async {
    Principal p = getUserPrincipal().getOrElse(() =>
    throw new NotAuthorizedException.withMessage("Please log in"));
    return (await data_sources.users.getById(p.name)).getOrElse(() =>
    throw new NotAuthorizedException.withMessage("User not found"));
  }

  Future<bool> validateUserPrivilege(String privilege) async {
    if(await userHasPrivilege(privilege))
      return true;
    throw new NotAuthorizedException();
  }

  Future<bool> userHasPrivilege(String privilege) async {
    User user = await getCurrentUser();
    if(user.privileges.contains(USER_PRIVILEGE_ADMIN)||user.privileges.contains(privilege))
      return true;

    throw false;
  }

}
