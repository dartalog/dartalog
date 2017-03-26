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

  Future<VoidMessage> delete(String id);
  @protected
  Future<VoidMessage> deleteWithCatch(String id) =>
      catchExceptionsAwait(() async {
        await idModel.delete(id);
        return new VoidMessage();
      });

  Future<List<IdNamePair>> getAllIdsAndNames();
  Future<T> getById(String id);

  //Future<PaginatedResponse<IdNamePair>> getPaginatedIdsAndNames({int offset: 0});
//  Future<PaginatedResponse<IdNamePair>> _getPaginatedIdsAndNamesWithCatch(
//      {int offset: 0, int count: DEFAULT_PER_PAGE}) async =>
//      _catchExceptionsAwait(() async =>
//      new PaginatedResponse<IdNamePair>.fromPaginatedData(
//          await idModel.getAllIdsAndNames()));

  Future<IdResponse> update(String id, T t);
  @protected
  Future<List<IdNamePair>> getAllIdsAndNamesWithCatch() async =>
      catchExceptionsAwait(() => idModel.getAllIdsAndNames());

  @protected
  Future<T> getByIdWithCatch(String id) =>
      catchExceptionsAwait(() async => idModel.getById(id));
  Future<IdResponse> updateWithCatch(String id, T t) =>
      catchExceptionsAwait(() async {
        String output = await idModel.update(id, t);
        return new IdResponse.fromId(output, this.generateRedirect(output));
      });
}
