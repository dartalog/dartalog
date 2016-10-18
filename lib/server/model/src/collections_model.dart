import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';

class CollectionsModel extends AIdNameBasedModel<Collection> {
  // TODO: Currently denys admins the ability to save collections that they are not curators for
  static final Logger _log = new Logger('CollectionsModel');
  @override
  Logger get childLogger => _log;
  ACollectionDataSource get dataSource => data_sources.itemCollections;

  @override
  String get defaultPrivilegeRequirement => UserPrivilege.curator;

  Future _verifyUserIsCurator(String collectionId) async {
    validateDefaultPrivilegeRequirement();
    Collection col = await this.getById(collectionId);
    if (!col.curators.contains(this.currentUserId))
      throw new ForbiddenException.withMessage(
          "You are not a curator for collection \"${col.name}\"");
  }

  @override
  Future validateDeletePrivileges(String id) => _verifyUserIsCurator(id);

  @override
  Future validateUpdatePrivileges(String id) => _verifyUserIsCurator(id);

  @override
  Future<List<Collection>> getAll() async {
    await validateGetAllPrivileges();

    List output;

    if (await userHasPrivilege(UserPrivilege.admin))
      output = await dataSource.getAll();
    else
      output = await dataSource.getAllForCurator(userPrincipal.get().name);

    for (dynamic t in output) performAdjustments(t);
    return output;
  }
}
