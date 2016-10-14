import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/api/responses/responses.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import 'a_id_resource.dart';

class ItemTypeResource extends AIdResource<ItemType> {
  static final Logger _log = new Logger('ItemTypeResource');
  @override
  Logger get childLogger => _log;

  model.ItemTypeModel get idModel => model.itemTypes;

  @ApiMethod(method: 'POST', path: '${API_ITEM_TYPES_PATH}/')
  Future<IdResponse> create(ItemType itemType) => createWithCatch(itemType);

  @ApiMethod(path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<ItemType> getById(String id, {bool includeFields: false}) =>
      catchExceptionsAwait(() => idModel.getById(id, includeFields: includeFields));

  @ApiMethod(path: '${API_ITEM_TYPES_PATH}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @ApiMethod(method: 'PUT', path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<IdResponse> update(String id, ItemType itemType) =>
      updateWithCatch(id, itemType);

  @ApiMethod(method: 'DELETE', path: '${API_ITEM_TYPES_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => deleteWithCatch(id);

  String generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_ITEM_TYPES_PATH}/${newId}";
}
