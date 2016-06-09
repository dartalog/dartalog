part of api;

class SetupResource extends AResource {
  static final Logger _log = new Logger('SetupResource');

  Logger get _logger => _log;

  @ApiMethod(path: '${API_SETUP_PATH}/database/')
  Future<List<String>> checkDatabase() async {
    return _catchExceptionsAwait(() async {
      await model.setup.checkDatabase();
      return ["Datebase is configured correctly"];
    });
  }

  @ApiMethod(method: 'POST', path: '${API_SETUP_PATH}/database/')
  Future<VoidMessage> setUpDatabase(DatabaseSetupRequest request) async {
    return _catchExceptionsAwait(() async {
      await model.setup.setDatabase();
      return new VoidMessage();
    });
  }

  @ApiMethod(path: '${API_SETUP_PATH}/admin_user/')
  Future<List<String>> checkForAdminUser() async {
    return _catchExceptionsAwait(() async {
      return await model.setup.checkForAdminUsers();
    });
  }


  @ApiMethod(method: 'POST', path: '${API_SETUP_PATH}/admin_user/')
  Future<IdResponse> createAdminUser(User request) async {
    return _catchExceptionsAwait(() async {
      String id = await model.setup.createAdminUser(request);
      return new IdResponse.fromId(id);
    });
  }


}
