part of api;

class UserResource extends AIdResource<User> {
  static final Logger _log = new Logger('UserResource');
  model.AIdNameBasedModel<User> get idModel => model.users;

  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${API_USERS_PATH}/')
  Future<IdResponse> create(User user) => _createWithCatch(user);

  @ApiMethod(path: '${API_USERS_PATH}/')
  Future<PaginatedResponse<IdNamePair>> getAllIdsAndNames({int offset: 0}) => _getAllIdsAndNamesWithCatch(offset: offset);

  @ApiMethod(path: '${API_USERS_PATH}/{id}/')
  Future<User> getById(String id) => _getByIdWithCatch(id);

  @ApiMethod(path: 'current_user/')
  Future<User> getMe() => _catchExceptionsAwait(() async {
    return await model.users.getMe();
  });


  @ApiMethod(method: 'PUT', path: '${API_USERS_PATH}/{id}/')
  Future<IdResponse> update(String id, User user) => _updateWithCatch(id, user);

  @ApiMethod(method: 'PUT', path: '${API_USERS_PATH}/{id}/password/')
  Future<VoidMessage> changePassword(String id, PasswordChangeRequest pcr) =>_catchExceptionsAwait(() async {
    await model.users.changePassword(id, pcr.currentPassword, pcr.newPassword);
    return new VoidMessage();
  });

  @ApiMethod(method: 'DELETE', path: '${API_USERS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => _deleteWithCatch(id);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_USERS_PATH}/${newId}";
}
