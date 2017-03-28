import 'dart:async';

import 'responses/id_response.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:meta/meta.dart';
import 'package:rpc/rpc.dart';

import 'a_resource.dart';
import 'a_id_resource.dart';

abstract class AIdNameResource<T extends AHumanFriendlyData> extends AIdResource<T> {

  @override
  model.AIdNameBasedModel<T> get idModel;

  //Future<PaginatedResponse<IdNamePair>> getPaginatedIdsAndNames({int offset: 0});
//  Future<PaginatedResponse<IdNamePair>> _getPaginatedIdsAndNamesWithCatch(
//      {int offset: 0, int count: DEFAULT_PER_PAGE}) async =>
//      _catchExceptionsAwait(() async =>
//      new PaginatedResponse<IdNamePair>.fromPaginatedData(
//          await idModel.getAllIdsAndNames()));

  Future<List<IdNamePair>> getAllIdsAndNamesWithCatch() async =>
      catchExceptionsAwait(() => idModel.getAllIdsAndNames());

  Future<List<IdNamePair>> getAllIdsAndNames();

}
