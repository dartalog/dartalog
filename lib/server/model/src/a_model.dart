part of model;

abstract class AModel {
  String get _currentUserId =>
      _userPrincipal.map((Principal p) => p.name).getOrDefault("");

  String get _defaultCreatePrivilegeRequirement => _defaultWritePrivilegeRequirement ;
  String get _defaultDeletePrivilegeRequirement => _defaultWritePrivilegeRequirement ;
  String get _defaultPrivilegeRequirement => UserPrivilege.admin;
  String get _defaultReadPrivilegeRequirement => _defaultPrivilegeRequirement;
  String get _defaultWritePrivilegeRequirement => _defaultPrivilegeRequirement;
  String get _defaultUpdatePrivilegeRequirement => _defaultWritePrivilegeRequirement ;

  Logger get _logger;

  bool get _userAuthenticated => _userPrincipal
      .map((Principal p) => true)
      .getOrDefault(false); // High-security defaults

  Option<Principal> get _userPrincipal => authenticatedContext()
      .map((AuthenticatedContext context) => context.principal);


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

  Future<bool> _validateCreatePrivilegeRequirement() =>
      _validateUserPrivilege(_defaultCreatePrivilegeRequirement);
  Future<bool> _validateDefaultPrivilegeRequirement() =>
      _validateUserPrivilege(_defaultPrivilegeRequirement);
  Future<bool> _validateDeletePrivilegeRequirement() =>
      _validateUserPrivilege(_defaultDeletePrivilegeRequirement);
  Future<bool> _validateReadPrivilegeRequirement() =>
      _validateUserPrivilege(_defaultReadPrivilegeRequirement);
  Future<bool> _validateUpdatePrivilegeRequirement() =>
      _validateUserPrivilege(_defaultUpdatePrivilegeRequirement);

  Future<bool> _validateUserPrivilege(String privilege) async {
    if (await _userHasPrivilege(privilege)) return true;
    throw new ForbiddenException.withMessage("${privilege} required");
  }
}
