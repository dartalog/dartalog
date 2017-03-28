import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import '../../item_api.dart';
import '../requests/item_action_request.dart';
import '../requests/bulk_item_action_request.dart';
import '../requests/transfer_request.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';

class ItemCopyResource extends AIdResource<ItemCopy> {
  static final Logger _log = new Logger('ItemCopyResource');
  static const String _apiPath = ItemApi.copiesPath;

  @override
  model.AUuidBasedModel<ItemCopy> get idModel => model.items.copies;


  @override
  Logger get childLogger => _log;

  @override
  @ApiMethod(method: 'POST', path: '$_apiPath/')
  Future<IdResponse> create(ItemCopy itemCopy) => createWithCatch(itemCopy);

  @override
  @ApiMethod(method: 'DELETE', path: '$_apiPath/{uuid}/')
  Future<VoidMessage> delete(String uuid) => throw new NotImplementedException();

  @override
  Future<ItemCopy> getByUuid(String uuid) => throw new NotImplementedException();

  @ApiMethod(path: '$_apiPath/{uuidOrUniqueId}/')
  Future<ItemCopy> getByUuidOrUniqueId(String uuidOrUniqueId,
          {bool includeCollection: false, bool includeItemSummary: false}) =>
      catchExceptionsAwait(() {
        if(isUuid(uuidOrUniqueId)) {
          return model.items.copies.getVisible(uuidOrUniqueId,
              includeCollection: includeCollection,
              includeItemSummary: includeItemSummary);
        } else {
          return model.items.copies.getVisibleByUniqueId(
              uuidOrUniqueId,
              includeCollection: includeCollection,
              includeItemSummary: includeItemSummary);
        }
      });

  @ApiMethod(path: '${ItemApi.itemsPath}/{itemUuidOrReadableId}/${ItemApi.copiesPath}/')
  Future<List<ItemCopy>> getVisibleForItem(String itemUuidOrReadableId,
          {bool includeCollection: false}) =>
      catchExceptionsAwait(() => model.items.copies
          .getVisibleForItem(itemUuidOrReadableId, includeCollection: includeCollection));

  @ApiMethod(
      method: 'PUT',
      path: '$_apiPath/{uuid}/action/')
  Future<VoidMessage> performAction(
          String uuid, ItemActionRequest actionRequest) =>
      catchExceptionsAwait(() async {
        //await model.items.copies.performAction(itemId, copy, actionRequest.action, actionRequest.actionerUserId);
        throw new Exception("Not Implemented");
        //return new VoidMessage();
      });

  @ApiMethod(method: 'PUT', path: '${ItemApi.bulkPath}/$_apiPath/action/')
  Future<VoidMessage> performBulkAction(BulkItemActionRequest actionRequest) =>
      catchExceptionsAwait(() async {
        await model.items.copies.performBulkAction(actionRequest.itemCopyUuids,
            actionRequest.action, actionRequest.actionerUserUuid);
        return new VoidMessage();
      });

  @ApiMethod(method: 'PUT', path: '${ItemApi.bulkPath}/$_apiPath/transfer/')
  Future<VoidMessage> transfer(TransferRequest actionRequest) =>
      catchExceptionsAwait(() async {
        await model.items.copies
            .transfer(actionRequest.itemCopyUuids, actionRequest.targetCollectionUuid);
        return new VoidMessage();
      });

  @override
  @ApiMethod(
      method: 'PUT', path: '$_apiPath/{uuid}/')
  Future<IdResponse> update(String uuid, ItemCopy itemCopy) => updateWithCatch(uuid, itemCopy);
}
