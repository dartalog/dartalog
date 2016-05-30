part of api;

class UserResource extends AIdResource<User> {
  static final Logger _log = new Logger('UserResource');
  model.AIdModel<User> get idModel => model.users;

  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${API_USERS_PATH}/')
  Future<IdResponse> create(User user) async {
    if(!isNullOrWhitespace(user.password))
      user.password = new crypt.Crypt.sha256(user.password).toString();
    return await _create(user);
  }

  @ApiMethod(path: '${API_USERS_PATH}/')
  Future<List<IdNamePairResponse>> getAllIdsAndNames() => _getAllIdsAndNames();

  @ApiMethod(path: '${API_USERS_PATH}/{id}/')
  Future<User> getById(String id) => _getById(id);

  @ApiMethod(method: 'PUT', path: '${API_USERS_PATH}/{id}/')
  Future<IdResponse> update(String id, User user) => _update(id, user);

  @ApiMethod(method: 'PUT', path: '${API_USERS_PATH}/{id}/password/')
  Future<VoidMessage> changePassword(String id, PasswordChangeRequest pcr) => _catchExceptions(_changePassword(id, pcr));
  Future<VoidMessage> _changePassword(String id, PasswordChangeRequest pcr) async {


      User user = await model.users.getById(id);
      pcr.validate(user);
      user.password = new crypt.Crypt.sha256(pcr.newPassword).toString();
      await model.users.write(user, id);
      return new VoidMessage();
  }

  @ApiMethod(method: 'DELETE', path: '${API_USERS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _delete(id);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_USERS_PATH}/${newId}";
}
