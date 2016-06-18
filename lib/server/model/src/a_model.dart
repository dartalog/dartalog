part of model;

abstract class AModel<T> {
  String get _currentUserId =>
      _userPrincipal.map((Principal p) => p.name).getOrDefault("");

  String get _defaultPrivilegeRequirement =>
      UserPrivilege.admin;
  String get _defaultCreatePrivilegeRequirement => _defaultPrivilegeRequirement;
  String get _defaultDeletePrivilegeRequirement => _defaultPrivilegeRequirement;
  String get _defaultUpdatePrivilegeRequirement => _defaultPrivilegeRequirement;
  String get _defaultReadPrivilegeRequirement => _defaultPrivilegeRequirement;

  Logger get _logger;

  bool get _userAuthenticated =>
      _userPrincipal.map((Principal p) => true).getOrDefault(false); // High-security defaults

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

  Future<bool> _userHasPrivilege(String userType) async {
    if (userType == UserPrivilege.none)
      return true; //None is equivalent to not being logged in, or logged in as a user with no privileges
    User user = await _getCurrentUser();
    return UserPrivilege.evaluate(userType, user.type);
  }

  Future<bool> _validateDefaultPrivilegeRequirement() =>
      _validateUserPrivilege(_defaultPrivilegeRequirement);
  Future<bool> _validateCreatePrivilegeRequirement() =>
      _validateUserPrivilege(_defaultCreatePrivilegeRequirement);
  Future<bool> _validateUpdatePrivilegeRequirement() =>
      _validateUserPrivilege(_defaultUpdatePrivilegeRequirement);
  Future<bool> _validateDeletePrivilegeRequirement() =>
      _validateUserPrivilege(_defaultDeletePrivilegeRequirement);
  Future<bool> _validateReadPrivilegeRequirement() =>
      _validateUserPrivilege(_defaultReadPrivilegeRequirement);



  Future<Map<String, String>> _validateFields(T t, bool creating);

  Future<bool> _validateUserPrivilege(String privilege) async {
    if (await _userHasPrivilege(privilege)) return true;
    throw new NotAuthorizedException();
  }
}
