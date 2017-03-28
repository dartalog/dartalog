import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';
import '../model.dart' as model;

class CollectionsModel extends AIdNameBasedModel<Collection> {
  // TODO: Currently denies admins the ability to save collections that they are not curators for - this may be fixed
  static final Logger _log = new Logger('CollectionsModel');
  @override
  Logger get loggerImpl => _log;

  @override
  ACollectionDataSource get dataSource => data_sources.itemCollections;

  @override
  String get defaultPrivilegeRequirement => UserPrivilege.curator;

  Future<Null> _verifyUserIsCurator(String collectionUuid) async {
    if (await userHasPrivilege(UserPrivilege.admin)) {
      return;
    }
    await validateDefaultPrivilegeRequirement();
    final Collection col = await this.getByUuid(collectionUuid);
    if (!col.curatorUuids.contains(this.currentUserUuid))
      throw new ForbiddenException.withMessage(
          "You are not a curator for collection \"${col.name}\"");
  }

  @override
  Future<String> delete(String uuid) async {
    await super.delete(uuid);
    await data_sources.itemCopies.deleteByCollection(uuid);
    return uuid;
  }

  @override
  Future<Null> validateDeletePrivileges(String uuid) =>
      _verifyUserIsCurator(uuid);

  @override
  Future<Null> validateUpdatePrivileges(String uuid) =>
      _verifyUserIsCurator(uuid);

  @override
  Future<List<Collection>> getAll() async {
    await validateGetAllPrivileges();

    List<Collection> output;

    if (await userHasPrivilege(UserPrivilege.admin))
      output = await dataSource.getAll();
    else
      output = await dataSource.getAllForCurator(userPrincipal.get().name);

    for (dynamic t in output) await  performAdjustments(t);
    return output;
  }
}
