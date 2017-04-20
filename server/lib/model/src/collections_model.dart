import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';
import '../model.dart' as model;

class CollectionsModel extends AIdNameBasedModel<Collection> {
  // TODO: Currently denies admins the ability to save collections that they are not curators for - this may be fixed
  static final Logger _log = new Logger('CollectionsModel');

  final ACollectionDataSource collectionDataSource;
  final AItemCopyDataSource itemCopyDataSource;

  CollectionsModel(this.collectionDataSource, this.itemCopyDataSource, AUserDataSource userDataSource): super(userDataSource);

  @override
  Logger get loggerImpl => _log;

  @override
  ACollectionDataSource get dataSource => collectionDataSource;

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
    await itemCopyDataSource.deleteByCollection(uuid);
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

    for (dynamic t in output) await performAdjustments(t);
    return output;
  }

  @override
  Future<Null> validateFieldsInternal(
      Map<String, String> fieldErrors, Collection collection,
      {String existingId: null}) async {
    if (collection.browserUuids == null) {
      fieldErrors["browserUuids"] = "Cannot be null";
    } else {
      for (String uuid in collection.browserUuids) {
        if (!await userDataSource.existsByUuid(uuid))
          fieldErrors["browserUuids"] = "Invalid user";
      }
    }

    if (collection.curatorUuids == null) {
      fieldErrors["curatorUuids"] = "Cannot be null";
    } else if (collection.curatorUuids.length == 0) {
      fieldErrors["curatorUuids"] = "Please specify at least one curator";
    } else {
      for (String uuid in collection.curatorUuids) {
        if (!await userDataSource.existsByUuid(uuid))
          fieldErrors["curatorUuids"] = "Invalid user";
      }
    }
  }
}
