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

class ItemCopyResource extends AResource {
  static final Logger _log = new Logger('ItemCopyResource');
  static const String _apiPath = ItemApi.itemsPath;

  @override
  Logger get childLogger => _log;

  @ApiMethod(method: 'POST', path: '$_apiPath/{itemId}/${ItemApi.copiesPath}/')
  Future<ItemCopyId> create(String itemId, ItemCopy itemCopy) =>
      catchExceptionsAwait(() => model.items.copies.create(itemId, itemCopy));

  String generateCopyRedirect(String itemId, int copy) =>
      "${generateRedirect(itemId)}/${ItemApi.copiesPath}/$copy";

  @ApiMethod(path: '$_apiPath/{itemId}/${ItemApi.copiesPath}/{copy}/')
  Future<ItemCopy> get(String itemId, int copy,
          {bool includeCollection: false, bool includeItemSummary: false}) =>
      catchExceptionsAwait(() => model.items.copies.getVisible(itemId, copy,
          includeCollection: includeCollection,
          includeItemSummary: includeItemSummary));

  @ApiMethod(path: '$_apiPath/copies/by_unique_id/{uniqueId}/')
  Future<ItemCopy> getByUniqueID(String uniqueId,
          {bool includeCollection: false, bool includeItemSummary: false}) =>
      catchExceptionsAwait(() => model.items.copies.getVisibleByUniqueId(
          uniqueId,
          includeCollection: includeCollection,
          includeItemSummary: includeItemSummary));

  @ApiMethod(path: '$_apiPath/{itemId}/${ItemApi.copiesPath}/')
  Future<List<ItemCopy>> getVisibleForItem(String itemId,
          {bool includeCollection: false}) =>
      catchExceptionsAwait(() => model.items.copies
          .getVisibleForItem(itemId, includeCollection: includeCollection));

  @ApiMethod(
      method: 'PUT',
      path: '$_apiPath/{itemId}/${ItemApi.copiesPath}/{copy}/action/')
  Future<VoidMessage> performAction(
          String itemId, int copy, ItemActionRequest actionRequest) =>
      catchExceptionsAwait(() async {
        //await model.items.copies.performAction(itemId, copy, actionRequest.action, actionRequest.actionerUserId);
        throw new Exception("Not Implemented");
        //return new VoidMessage();
      });

  @ApiMethod(method: 'PUT', path: '$_apiPath/copies/action/')
  Future<VoidMessage> performBulkAction(BulkItemActionRequest actionRequest) =>
      catchExceptionsAwait(() async {
        await model.items.copies.performBulkAction(actionRequest.itemCopies,
            actionRequest.action, actionRequest.actionerUserId);
        return new VoidMessage();
      });

  @ApiMethod(method: 'PUT', path: '$_apiPath/copies/transfer/')
  Future<VoidMessage> transfer(TransferRequest actionRequest) =>
      catchExceptionsAwait(() async {
        await model.items.copies
            .transfer(actionRequest.itemCopies, actionRequest.targetCollection);
        return new VoidMessage();
      });

  @ApiMethod(
      method: 'PUT', path: '$_apiPath/{itemId}/${ItemApi.copiesPath}/{copy}/')
  Future<ItemCopyId> update(String itemId, int copy, ItemCopy itemCopy) =>
      catchExceptionsAwait(
          () => model.items.copies.update(itemId, copy, itemCopy));
}
