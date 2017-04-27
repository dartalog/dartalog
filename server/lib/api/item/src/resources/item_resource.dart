import 'dart:async';

import 'package:dartalog_shared/global.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import '../../item_api.dart';
import 'item_copy_resource.dart';
import '../requests/create_item_request.dart';
import '../requests/update_item_request.dart';
import 'package:dartalog/tools.dart';

class ItemResource extends AIdNameResource<Item> {
  static final Logger _log = new Logger('ItemResource');
  @override
  Logger get childLogger => _log;

  static const String _apiPath = ItemApi.itemsPath;

  final ItemModel itemModel;
  ItemResource(this.itemModel, this.copies);

  @ApiResource()
  final ItemCopyResource copies;

  @override
  AIdNameBasedModel<Item> get idModel => itemModel;

  @ApiMethod(method: 'POST', path: '$_apiPath/')
  Future<IdResponse> createItem(CreateItemRequest newItem) async {
    List<List<int>> files;
    if (newItem.files != null) {
      files = convertMediaMessagesToIntLists(newItem.files);
    }
    final String output = await catchExceptionsAwait(() => itemModel
        .createWithCopy(newItem.item, newItem.collectionUuid,
            uniqueId: newItem.uniqueId, files: files));
    return new IdResponse.fromId(output, generateRedirect(output));
  }



  // Created only to satisfy the interface; should not be used, as creating a copy with each item should be required
  @override
  Future<IdResponse> create(Item item) =>
      throw new NotImplementedException("Use createItem instead");

  @override
  @ApiMethod(method: 'DELETE', path: '$_apiPath/{uuid}/')
  Future<VoidMessage> delete(String uuid) => deleteWithCatch(uuid);

  @override
  Future<List<IdNamePair>> getAllIdsAndNames() =>
      throw new Exception("Do not use");

  @ApiMethod(path: '$_apiPath/')
  Future<PaginatedResponse<ItemSummary>> getVisibleSummaries(
          {int page: 0, int perPage: defaultPerPage}) =>
      catchExceptionsAwait(() async =>
          new PaginatedResponse<ItemSummary>.convertPaginatedData(
              await itemModel.getVisible(page: page, perPage: perPage),
              (Item item) => new ItemSummary.copyItem(item)));

  @override
  Future<Item> getByUuid(String uuid) => throw new NotImplementedException();

  @ApiMethod(path: '$_apiPath/{uuidOrReadableId}/')
  Future<Item> getByUuidOrReadableId(String uuidOrReadableId,
          {bool includeType: false,
          bool includeFields: false,
          bool includeCopies: false,
          bool includeCopyCollection: false}) =>
      catchExceptionsAwait(() => itemModel.getByUuidOrReadableId(
          uuidOrReadableId,
          includeType: includeType,
          includeCopies: includeCopies,
          includeFields: includeFields,
          includeCopyCollection: includeCopyCollection));

  @ApiMethod(path: 'search/{query}/')
  Future<PaginatedResponse<ItemSummary>> searchVisible(String query,
          {int page: 0, int perPage: defaultPerPage}) =>
      catchExceptionsAwait(() async =>
          new PaginatedResponse<ItemSummary>.convertPaginatedData(
              await itemModel
                  .searchVisible(query, page: page, perPage: perPage),
              (Item item) => new ItemSummary.copyItem(item)));

  @override
  Future<IdResponse> update(String uuid, Item item) =>
      throw new NotImplementedException("User updateItem");

  @ApiMethod(method: 'PUT', path: '$_apiPath/{uuid}/')
  Future<IdResponse> updateItem(String uuid, UpdateItemRequest request) =>
      updateWithCatch(uuid, request.item, mediaMessages: request.files);
}
