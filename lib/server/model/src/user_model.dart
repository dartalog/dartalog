import 'dart:async';
import 'package:crypt/crypt.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';

class UserModel extends AIdNameBasedModel<User> {
  static final Logger _log = new Logger('UserModel');
  @override
  Logger get childLogger => _log;

  AUserDataSource get dataSource => data_sources.users;

  @override
  String get _defaultReadPrivilegeRequirement => UserPrivilege.checkout;

  @override
  Future _validateFieldsInternal(
      Map field_errors, User user, bool creating) async {
    if (creating || !isNullOrWhitespace(user.password)) {
      _validatePassword(field_errors, user.password);
    }
    if (isNullOrWhitespace(user.type)) {
      field_errors["type"] = "Required";
    } else {
      if (!UserPrivilege.values.contains(user.type))
        field_errors["type"] = "Invalid";
    }
  }

  _validatePassword(Map field_errors, String password) {
    if (isNullOrWhitespace(password)) {
      field_errors["password"] = "Required";
    } else if (password.length < 8) {
      //TODO: Additional restrictions? Keep them sane.
      field_errors["password"] = "Must be at least 8 digits long";
    }
  }

  Future<User> getMe() async {
    if (!userAuthenticated) throw new NotAuthorizedException();

    Option<User> output = await dataSource.getById(userPrincipal.get().name);
    return output.getOrElse(() =>
        throw new Exception("Authenticated user not present in database"));
  }

  @override
  Future<String> create(User user, {List<String> privileges}) async {
    await validateCreatePrivileges();

    String output = await super.create(user);

    await _setPassword(output, user.password);

    return output;
  }

  @override
  Future<String> update(String id, User user) async {
    id = normalizeId(id);
    await validateUpdatePrivileges(id);
    // Only admin can update...for now

    String output = await super.update(id, user);

    if (!isNullOrWhitespace(user.password))
      await _setPassword(output, user.password);

    return output;
  }

  Future changePassword(
      String id, String currentPassword, String newPassword) async {
    id = normalizeId(id);
    if (!userAuthenticated) {
      throw new NotAuthorizedException();
    }
    if (currentUserId != id)
      throw new ForbiddenException.withMessage(
          "You do not have permission to change another user's password");

    String userPassword = (await data_sources.users.getPasswordHash(id))
        .getOrElse(() =>
            throw new Exception("User ${id} does not have a current password"));

    await DataValidationException.PerformValidation((Map field_errors) async {
      if (isNullOrWhitespace(currentPassword)) {
        field_errors["currentPassword"] = "Required";
      } else if (!verifyPassword(userPassword, currentPassword)) {
        field_errors["currentPassword"] = "Incorrect";
      }
    });
    await _setPassword(id, newPassword);
  }

  Future _setPassword(String id, String newPassword) async {
    id = normalizeId(id);
    await DataValidationException.PerformValidation((Map field_errors) async {
      _validatePassword(field_errors, newPassword);
    });

    String passwordHash = hashPassword(newPassword);
    await dataSource.setPassword(id, passwordHash);
  }

  String hashPassword(String password) {
    return new Crypt.sha256(password).toString();
  }

  bool verifyPassword(String hash, String password) =>
      new Crypt(hash).match(password);
}
