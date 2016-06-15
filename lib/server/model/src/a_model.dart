part of model;

abstract class AModel<T> {
  String get _currentUserId =>
      _userPrincipal.map((Principal p) => p.name).getOrDefault("");

  Logger get _logger;

  bool get _userAuthenticated =>
      _userPrincipal.map((Principal p) => true).getOrDefault(false);

  String get _defaultPrivilegeRequirement => USER_PRIVILEGE_NONE;
  Future<bool> _validateDefaultPrivilegeRequirement() => _validateUserPrivilege(_defaultPrivilegeRequirement);



  Option<Principal> get _userPrincipal => authenticatedContext()
      .map((AuthenticatedContext context) => context.principal);

  Future validate(T t, bool creating) =>
      DataValidationException.PerformValidation((Map output) async =>
          output.addAll(await _validateFields(t, creating)));

  Future<User> _getCurrentUser() async {
    Principal p = _userPrincipal.getOrElse(
        () => throw new NotAuthorizedException.withMessage("Please log in"));
    return (await data_sources.users.getById(p.name)).getOrElse(
        () => throw new NotAuthorizedException.withMessage("User not found"));
  }

  Future<bool> _userHasPrivilege(String privilege) async {
    if(privilege==USER_PRIVILEGE_NONE)
      return true; //None is equivalent to not being logged in, or logged in as a user with no privileges
    User user = await _getCurrentUser();
    if (user.privileges.contains(USER_PRIVILEGE_ADMIN) ||
        user.privileges.contains(privilege)) return true;

    throw false;
  }

  Future<Map<String, String>> _validateFields(T t, bool creating);

  Future<bool> _validateUserPrivilege(String privilege) async {
    if (await _userHasPrivilege(privilege)) return true;
    throw new NotAuthorizedException();
  }

}
