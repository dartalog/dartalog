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
  model.AIdNameBasedModel<Collection> get idModel => model.collections;

  @override
  Logger get childLogger => _log;

  @ApiMethod(method: 'POST', path: '${ItemApi.collectionsPath}/')
  Future<IdResponse> create(Collection collection) =>
      createWithCatch(collection);

  @ApiMethod(method: 'DELETE', path: '${ItemApi.collectionsPath}/{id}/')
  Future<VoidMessage> delete(String id) => deleteWithCatch(id);

  @ApiMethod(path: '${ItemApi.collectionsPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @ApiMethod(path: '${ItemApi.collectionsPath}/{id}/')
  Future<Collection> getById(String id) => getByIdWithCatch(id);

  @ApiMethod(method: 'PUT', path: '${ItemApi.collectionsPath}/{id}/')
  Future<IdResponse> update(String id, Collection collection) =>
      updateWithCatch(id, collection);

  @override
  String generateRedirect(String newId) =>
      "${serverApiRoot}${ItemApi.collectionsPath}/${newId}";
}
