import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import '../../item_api.dart';

class ItemTypeResource extends AIdResource<ItemType> {
  static final Logger _log = new Logger('ItemTypeResource');
  @override
  Logger get childLogger => _log;

  model.ItemTypeModel get idModel => model.itemTypes;

  @ApiMethod(method: 'POST', path: '${ItemApi.itemTypesPath}/')
  Future<IdResponse> create(ItemType itemType) => createWithCatch(itemType);

  @ApiMethod(path: '${ItemApi.itemTypesPath}/{id}/')
  Future<ItemType> getById(String id, {bool includeFields: false}) =>
      catchExceptionsAwait(
          () => idModel.getById(id, includeFields: includeFields));

  @ApiMethod(path: '${ItemApi.itemTypesPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @ApiMethod(method: 'PUT', path: '${ItemApi.itemTypesPath}/{id}/')
  Future<IdResponse> update(String id, ItemType itemType) =>
      updateWithCatch(id, itemType);

  @ApiMethod(method: 'DELETE', path: '${ItemApi.itemTypesPath}/{id}/')
  Future<VoidMessage> delete(String id) => deleteWithCatch(id);

  String generateRedirect(String newId) =>
      "${serverApiRoot}${ItemApi.itemTypesPath}/${newId}";
}
