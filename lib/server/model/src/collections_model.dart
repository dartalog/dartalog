part of model;

class CollectionsModel extends AIdNameBasedModel<Collection> {
  static final Logger _log = new Logger('CollectionsModel');
  Logger get _logger => _log;
  ACollectionDataSource get dataSource => data_sources.itemCollections;

  String get _defaultPrivilegeRequirement => USER_PRIVILEGE_CREATE;

  Future _verifyUserIsCurator(String collectionId) async {
    _validateDefaultPrivilegeRequirement();
    Collection col = await this.getById(collectionId);
    if(!col.curators.contains(this._currentUserId))
      throw new NotAuthorizedException.withMessage("You are not a curator for collection \"${col.name}\"");
  }

  @override
  Future delete(String id) async {
    await _verifyUserIsCurator(id);
    await dataSource.delete(id);
  }

  @override
  Future<List<Collection>> getAll() async {
    await _validateDefaultPrivilegeRequirement();

    List output;

    if(await _userHasPrivilege(USER_PRIVILEGE_ADMIN))
      output = await dataSource.getAll();
    else
      output = await dataSource.getAllForCurator(_userPrincipal.get().name);

    for (dynamic t in output) _performAdjustments(t);
    return output;

  }

}