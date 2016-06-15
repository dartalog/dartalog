part of model;

class CollectionsModel extends AIdNameBasedModel<Collection> {
  static final Logger _log = new Logger('CollectionsModel');
  Logger get _logger => _log;
  ACollectionDataSource get dataSource => data_sources.itemCollections;

  @override
  Future<List<Collection>> getAll() async {
    await _validateUserPrivilege(USER_PRIVILEGE_CREATE);

    List output;

    if(await _userHasPrivilege(USER_PRIVILEGE_ADMIN))
      output = await dataSource.getAll();
    else
      output = await dataSource.getAllForCurator(_userPrincipal.get().name);

    for (dynamic t in output) _performAdjustments(t);
    return output;

  }

}