import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/api/item/item_api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

class CollectionResource extends AIdResource<Collection> {
  static final Logger _log = new Logger('CollectionResource');

  @override
  model.AIdNameBasedModel<Collection> get idModel => model.collections;

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
  @ApiMethod(method: 'PUT', path: '${ItemApi.collectionsPath}/{id}/')
  Future<IdResponse> update(String id, Collection collection) =>
      updateWithCatch(id, collection);

  @override
  String generateRedirect(String newId) =>
      "$serverApiRoot${ItemApi.collectionsPath}/$newId";
}
