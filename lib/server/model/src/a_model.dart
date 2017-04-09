import 'dart:async';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:shelf_auth/shelf_auth.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:meta/meta.dart';

abstract class AModel {
  /// This is for testing ONLY, do not use for anything!
  static User AuthenticationOverride;

  @protected
  String get currentUserUuid =>
      userPrincipal.map((Principal p) => p.name).getOrDefault("");

  @protected
  String get defaultCreatePrivilegeRequirement =>
      defaultWritePrivilegeRequirement;
  @protected
  String get defaultDeletePrivilegeRequirement =>
      defaultWritePrivilegeRequirement;
  @protected
  String get defaultPrivilegeRequirement => UserPrivilege.admin;
  @protected
  String get defaultReadPrivilegeRequirement => defaultPrivilegeRequirement;
  @protected
  String get defaultUpdatePrivilegeRequirement =>
      defaultWritePrivilegeRequirement;
  @protected
  String get defaultWritePrivilegeRequirement => defaultPrivilegeRequirement;

  @protected
  Logger get loggerImpl;

  @protected
  bool get userAuthenticated {
    if(AuthenticationOverride!=null)
      return true;

    return userPrincipal
        .map((Principal p) => true)
        .getOrDefault(false); // High-security defaults
  }

  @protected
  Option<Principal> get userPrincipal => authenticatedContext()
      .map((AuthenticatedContext<Principal> context) => context.principal);

  @protected
  Future<User> getCurrentUser() async {
    if(AModel.AuthenticationOverride!=null)
      return AModel.AuthenticationOverride;

    final Principal p = userPrincipal.getOrElse(
        () => throw new NotAuthorizedException.withMessage("Please log in"));
    return (await data_sources.users.getByUuid(p.name)).getOrElse(
        () => throw new NotAuthorizedException.withMessage("User not found"));
  }

  @protected
  Future<bool> userHasPrivilege(String userType) async {
    if (userType == UserPrivilege.none)
      return true; //None is equivalent to not being logged in, or logged in as a user with no privileges
    final User user = await getCurrentUser();
    return UserPrivilege.evaluate(userType, user.type);
  }

  @protected
  Future<bool> validateCreatePrivilegeRequirement() =>
      validateUserPrivilege(defaultCreatePrivilegeRequirement);

  @protected
  Future<Null> validateCreatePrivileges() async {
    if (!userAuthenticated) {
      throw new NotAuthorizedException();
    }
    await validateCreatePrivilegeRequirement();
  }

  @protected
  Future<bool> validateDefaultPrivilegeRequirement() =>
      validateUserPrivilege(defaultPrivilegeRequirement);

  @protected
  Future<bool> validateDeletePrivilegeRequirement() =>
      validateUserPrivilege(defaultDeletePrivilegeRequirement);

  @protected
  Future<Null> validateDeletePrivileges(String id) async {
    if (!userAuthenticated) {
      throw new NotAuthorizedException();
    }
    await validateDeletePrivilegeRequirement();
  }

  @protected
  Future<Null> validateGetPrivileges() async {
    await validateReadPrivilegeRequirement();
  }

  @protected
  Future<bool> validateReadPrivilegeRequirement() =>
      validateUserPrivilege(defaultReadPrivilegeRequirement);

  @protected
  Future<bool> validateUpdatePrivilegeRequirement() =>
      validateUserPrivilege(defaultUpdatePrivilegeRequirement);

  @protected
  Future<Null> validateUpdatePrivileges(String uuid) async {
    if (!userAuthenticated) {
      throw new NotAuthorizedException();
    }
    await validateUpdatePrivilegeRequirement();
  }

  @protected
  Future<bool> validateUserPrivilege(String privilege) async {
    if (await userHasPrivilege(privilege)) return true;
    throw new ForbiddenException.withMessage("$privilege required");
  }
}
