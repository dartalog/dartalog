import 'dart:async';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:shelf_auth/shelf_auth.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/server.dart';
import 'user_model.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/data_sources/data_sources.dart';
import 'package:meta/meta.dart';
import 'package:dartalog_shared/tools.dart';

abstract class AModel {
  /// Manually sets the current logged-in (or not logged-in) user.
  @visibleForTesting
  static void overrideCurrentUser(String uuid) {
    if (StringTools.isNullOrWhitespace(uuid)) {
      _authenticationOverride = new None<Principal>();
    } else {
      _authenticationOverride = new Some<Principal>(new Principal(uuid));
    }
  }

  /// Clears out all current user overrides, even an override of "un-authenticated".
  @visibleForTesting
  static void clearCurrentUserOverride() => _authenticationOverride = null;
  static Option<Principal> _authenticationOverride;
  // TODO: Get this not to be static so that it's carried along with the server instance.

  final AUserDataSource userDataSource;
  AModel(this.userDataSource);

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
    return userPrincipal.isNotEmpty;
  }

  @protected
  Option<Principal> get userPrincipal {
    if (_authenticationOverride == null) {
      return authenticatedContext()
          .map((AuthenticatedContext<Principal> context) => context.principal);
    } else {
      return _authenticationOverride;
    }
  }

  @protected
  Future<User> getCurrentUser() async {
    final Principal p = userPrincipal.getOrElse(
        () => throw new UnauthorizedException.withMessage("Please log in"));
    return (await userDataSource.getByUuid(p.name)).getOrElse(
        () => throw new UnauthorizedException.withMessage("User not found"));
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
      throw new UnauthorizedException();
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
      throw new UnauthorizedException();
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
      throw new UnauthorizedException();
    }
    await validateUpdatePrivilegeRequirement();
  }

  @protected
  Future<bool> validateUserPrivilege(String privilege) async {
    if (await userHasPrivilege(privilege)) return true;
    throw new ForbiddenException.withMessage("$privilege required");
  }
}
