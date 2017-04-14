import 'dart:async';
import 'package:crypt/crypt.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';

class UserModel extends AIdNameBasedModel<User> {
  static final Logger _log = new Logger('UserModel');
  @override
  Logger get loggerImpl => _log;

  @override
  AUserDataSource get dataSource => data_sources.users;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.checkout;

  @override
  Future<Null> validateFieldsInternal(
      Map<String, String> fieldErrors, User user,
      {String existingId: null}) async {
    if (StringTools.isNullOrWhitespace(existingId) ||
        !StringTools.isNullOrWhitespace(user.password)) {
      _validatePassword(fieldErrors, user.password);
    }
    if (StringTools.isNullOrWhitespace(user.type)) {
      fieldErrors["type"] = "Required";
    } else {
      if (!UserPrivilege.values.contains(user.type))
        fieldErrors["type"] = "Invalid";
    }

    if (StringTools.isNullOrWhitespace(user.email)) {
      fieldErrors["email"] = "Required";
    } else if(!isValidEmail(user.email)) {
      fieldErrors["email"] = "Invalid";
    }
  }

  void _validatePassword(Map<String, String> fieldErrors, String password) {
    if (StringTools.isNullOrWhitespace(password)) {
      fieldErrors["password"] = "Required";
    } else if (password.length < 8) {
      //TODO: Additional restrictions? Keep them sane.
      fieldErrors["password"] = "Must be at least 8 digits long";
    }
  }

  Future<User> getMe() async {
    if (!userAuthenticated) throw new UnauthorizedException();

    final Option<User> output =
        await dataSource.getByUuid(userPrincipal.get().name);
    return output.getOrElse(() =>
        throw new Exception("Authenticated user not present in database"));
  }

  Future<String> createUserWith(String username, String email, String password, String type,
      {bool bypassAuthentication: false}) async {
    final User newUser = new User();
    newUser.readableId = username;
    newUser.name = username;
    newUser.email = email;
    newUser.password = password;
    newUser.type = type;
    return await create(newUser, bypassAuthentication: bypassAuthentication);
  }

  @override
  Future<String> create(User user,
      {List<String> privileges, bool bypassAuthentication: false, bool keepUuid: false}) async {
    final String output =
        await super.create(user, bypassAuthentication: bypassAuthentication, keepUuid: keepUuid);

    await _setPassword(output, user.password);

    return output;
  }

  @override
  Future<String> update(String id, User user, {bool bypassAuthentication: false}) async {
    // TODO: Only admin can update...for now

    final String output = await super.update(id, user, bypassAuthentication: bypassAuthentication);

    if (!StringTools.isNullOrWhitespace(user.password))
      await _setPassword(output, user.password);

    return output;
  }

  Future<Null> changePassword(
      String uuid, String currentPassword, String newPassword) async {
    if (!userAuthenticated) {
      throw new UnauthorizedException();
    }
    if (currentUserUuid != uuid)
      throw new ForbiddenException.withMessage(
          "You do not have permission to change another user's password");

    final String userPassword = (await data_sources.users.getPasswordHashByUuid(uuid))
        .getOrElse(() =>
            throw new Exception("User $uuid does not have a current password"));

    await DataValidationException
        .performValidation((Map<String, String> fieldErrors) async {
      if (StringTools.isNullOrWhitespace(currentPassword)) {
        fieldErrors["currentPassword"] = "Required";
      } else if (!verifyPassword(userPassword, currentPassword)) {
        fieldErrors["currentPassword"] = "Incorrect";
      }
    });
    await _setPassword(uuid, newPassword);
  }

  Future<Null> _setPassword(String uuid, String newPassword) async {
    await DataValidationException
        .performValidation((Map<String, String> fieldErrors) async {
      _validatePassword(fieldErrors, newPassword);
    });

    final String passwordHash = hashPassword(newPassword);
    await dataSource.setPassword(uuid, passwordHash);
  }

  String hashPassword(String password) {
    return new Crypt.sha256(password).toString();
  }

  bool verifyPassword(String hash, String password) =>
      new Crypt(hash).match(password);
}
