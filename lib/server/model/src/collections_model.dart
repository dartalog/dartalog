part of model;

class CollectionsModel extends AIdNameBasedModel<Collection> {
  static final Logger _log = new Logger('CollectionsModel');
  Logger get _logger => _log;
  ACollectionDataSource get dataSource => data_sources.itemCollections;

  @override
  String get _defaultPrivilegeRequirement => UserPrivilege.curator;

  Future _verifyUserIsCurator(String collectionId) async {
    _validateDefaultPrivilegeRequirement();
    Collection col = await this.getById(collectionId);
    if(!col.curators.contains(this._currentUserId))
      throw new ForbiddenException.withMessage("You are not a curator for collection \"${col.name}\"");
  }

  @override
  Future _validateDeletePrivileges(String id) => _verifyUserIsCurator(id);

  @override
  Future _validateUpdatePrivileges(String id) => _verifyUserIsCurator(id);

  @override
  Future<List<Collection>> getAll() async {
    await _validateGetAllPrivileges();

    List output;

    if(await _userHasPrivilege(UserPrivilege.admin))
      output = await dataSource.getAll();
    else
      output = await dataSource.getAllForCurator(_userPrincipal.get().name);

    for (dynamic t in output) _performAdjustments(t);
    return output;

  }

}