import 'dart:async';

import 'responses/id_response.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:meta/meta.dart';
import 'package:rpc/rpc.dart';

import 'a_resource.dart';

abstract class AIdResource<T extends AHumanFriendlyData> extends AResource {
  model.AIdNameBasedModel<T> get idModel;

  Future<IdResponse> create(T t);
  @protected
  Future<IdResponse> createWithCatch(T t) => catchExceptionsAwait(() async {
        final String output = await idModel.create(t);
        return new IdResponse.fromId(output, this.generateRedirect(output));
      });

  Future<VoidMessage> delete(String uuid);
  @protected
  Future<VoidMessage> deleteWithCatch(String uuid) =>
      catchExceptionsAwait(() async {
        await idModel.delete(uuid);
        return new VoidMessage();
      });

  Future<List<IdNamePair>> getAllIdsAndNames();
  Future<T> getByUuid(String uuid);

  //Future<PaginatedResponse<IdNamePair>> getPaginatedIdsAndNames({int offset: 0});
//  Future<PaginatedResponse<IdNamePair>> _getPaginatedIdsAndNamesWithCatch(
//      {int offset: 0, int count: DEFAULT_PER_PAGE}) async =>
//      _catchExceptionsAwait(() async =>
//      new PaginatedResponse<IdNamePair>.fromPaginatedData(
//          await idModel.getAllIdsAndNames()));

  Future<IdResponse> update(String uuid, T t);
  @protected
  Future<List<IdNamePair>> getAllIdsAndNamesWithCatch() async =>
      catchExceptionsAwait(() => idModel.getAllIdsAndNames());

  @protected
  Future<T> getByUuidWithCatch(String uuid) =>
      catchExceptionsAwait(() async => idModel.getByUuid(uuid));

  Future<IdResponse> updateWithCatch(String uuid, T t) =>
      catchExceptionsAwait(() async {
        final String output = await idModel.update(uuid, t);
        return new IdResponse.fromId(output, this.generateRedirect(output));
      });
}
