part of model;

class UserModel extends AIdNameBasedModel<User> {
  static final Logger _log = new Logger('UserModel');
  Logger get _logger => _log;

  AUserDataSource get dataSource =>
      data_sources.users;

  Future<User> getMe() async {
    if(!userAuthenticated())
      throw new NotAuthorizedException();

    Option<Principal> princ = getUserPrincipal();
    Option<User> output = await dataSource.getById(princ.get().name);
    return output.getOrElse(() =>throw new Exception("Authenticated user not present in database"));
  }

  @override
  Future<String> create(User user) async {
//    if (!userAuthenticated()) {
//      throw new NotAuthorizedException();
//    }
    if(!isNullOrWhitespace(user.password))
      user.password = new Crypt.sha256(user.password).toString();
    await super.create(user);
  }

  Future changePassword(
      String id, String currentPassword, String newPassword) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }
    User user = await this.getById(id);

    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(currentPassword)) {
      field_errors["currentPassword"] = "Required";
    } else if (!verifyPassword(user, currentPassword)) {
      field_errors["currentPassword"] = "Incorrect";
    }

    if (isNullOrWhitespace(newPassword)) {
      field_errors["newPassword"] = "Required";
    } else if (newPassword.length < 8) {
      //TODO: Additional restrictions? Keep them sane.
      field_errors["newPassword"] = "Must be at least 8 digits long";
    }

    if (field_errors.length > 0) {
      throw new DataValidationException.WithFieldErrors(
          "Invalid input", field_errors);
    }

    user.password = new Crypt.sha256(newPassword).toString();
    await dataSource.write(user, id);
  }

  bool verifyPassword(User user, String password) =>
      new Crypt(user.password).match(password);
}
