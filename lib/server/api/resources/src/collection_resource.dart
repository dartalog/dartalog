import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/api/responses/responses.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import 'a_id_resource.dart';

class CollectionResource extends AIdResource<Collection> {
  static final Logger _log = new Logger('CollectionResource');
  model.AIdNameBasedModel<Collection> get idModel => model.collections;

  @override
  Logger get childLogger => _log;

  @ApiMethod(method: 'POST', path: '${API_COLLECTIONS_PATH}/')
  Future<IdResponse> create(Collection collection) =>
      createWithCatch(collection);

  @ApiMethod(method: 'DELETE', path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => deleteWithCatch(id);

  @ApiMethod(path: '${API_COLLECTIONS_PATH}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @ApiMethod(path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<Collection> getById(String id) => getByIdWithCatch(id);

  @ApiMethod(method: 'PUT', path: '${API_COLLECTIONS_PATH}/{id}/')
  Future<IdResponse> update(String id, Collection collection) =>
      updateWithCatch(id, collection);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_COLLECTIONS_PATH}/${newId}";
}
