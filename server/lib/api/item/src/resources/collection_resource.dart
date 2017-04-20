import 'dart:async';

import 'package:dartalog/api/api.dart';
import 'package:dartalog/api/item/item_api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

class CollectionResource extends AIdNameResource<Collection> {
  static final Logger _log = new Logger('CollectionResource');

  final CollectionsModel collectionsModel;
  @override
  AIdNameBasedModel<Collection> get idModel => collectionsModel;

  CollectionResource(this.collectionsModel);

  @override
  Logger get childLogger => _log;

  @override
  @ApiMethod(method: 'POST', path: '${ItemApi.collectionsPath}/')
  Future<IdResponse> create(Collection collection) =>
      createWithCatch(collection);

  @override
  @ApiMethod(method: 'DELETE', path: '${ItemApi.collectionsPath}/{uuid}/')
  Future<VoidMessage> delete(String uuid) => deleteWithCatch(uuid);

  @override
  @ApiMethod(path: '${ItemApi.collectionsPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @override
  @ApiMethod(path: '${ItemApi.collectionsPath}/{uuid}/')
  Future<Collection> getByUuid(String uuid) => getByUuidWithCatch(uuid);

  @override
  @ApiMethod(method: 'PUT', path: '${ItemApi.collectionsPath}/{uuid}/')
  Future<IdResponse> update(String uuid, Collection collection) =>
      updateWithCatch(uuid, collection);

  @override
  String generateRedirect(String newId) =>
      "$serverApiRoot${ItemApi.collectionsPath}/$newId";
}
