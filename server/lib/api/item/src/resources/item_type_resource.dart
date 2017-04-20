import 'dart:async';

import 'package:dartalog/api/api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import '../../item_api.dart';

class ItemTypeResource extends AIdNameResource<ItemType> {
  static final Logger _log = new Logger('ItemTypeResource');
  @override
  Logger get childLogger => _log;

  final ItemTypeModel itemTypeModel;

  ItemTypeResource(this.itemTypeModel);

  @override
  ItemTypeModel get idModel => itemTypeModel;

  @override
  @ApiMethod(method: 'POST', path: '${ItemApi.itemTypesPath}/')
  Future<IdResponse> create(ItemType itemType) => createWithCatch(itemType);

  @override
  @ApiMethod(path: '${ItemApi.itemTypesPath}/{uuid}/')
  Future<ItemType> getByUuid(String uuid, {bool includeFields: false}) =>
      catchExceptionsAwait(
          () => idModel.getByUuid(uuid, includeFields: includeFields));

  @override
  @ApiMethod(path: '${ItemApi.itemTypesPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @override
  @ApiMethod(method: 'PUT', path: '${ItemApi.itemTypesPath}/{uuid}/')
  Future<IdResponse> update(String uuid, ItemType itemType) =>
      updateWithCatch(uuid, itemType);

  @override
  @ApiMethod(method: 'DELETE', path: '${ItemApi.itemTypesPath}/{uuid}/')
  Future<VoidMessage> delete(String uuid) => deleteWithCatch(uuid);

  @override
  String generateRedirect(String newUuid) =>
      "$serverApiRoot${ItemApi.itemTypesPath}/$newUuid";

  @ApiMethod(path: '${ItemApi.templatesPath}/${ItemApi.itemTypesPath}/')
  Future<List<IdNamePair>> getAllTemplates() =>
      itemTypeModel.getAllTemplateIds();

  @ApiMethod(
      method: 'PUT', path: '${ItemApi.templatesPath}/${ItemApi.itemTypesPath}/')
  Future<IdResponse> applyTemplate(IdRequest uuid) async =>
      new IdResponse.fromId(await itemTypeModel.applyTemplate(uuid.id),
          generateRedirect(uuid.id));
}
