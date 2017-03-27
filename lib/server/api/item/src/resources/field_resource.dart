import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/api/item/item_api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

class FieldResource extends AIdResource<Field> {
  static final Logger _log = new Logger('FieldResource');
  model.AIdNameBasedModel<Field> get idModel => model.fields;

  @override
  Logger get childLogger => _log;

  @override
  @ApiMethod(method: 'POST', path: '${ItemApi.fieldsPath}/')
  Future<IdResponse> create(Field field) => createWithCatch(field);

  @override
  @ApiMethod(path: '${ItemApi.fieldsPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @ApiMethod(path: '${ItemApi.fieldsPath}/{uuid}/')
  Future<Field> getById(String uuid) => getByUuidWithCatch(uuid);

  @ApiMethod(method: 'PUT', path: '${ItemApi.fieldsPath}/{uuid}/')
  Future<IdResponse> update(String uuid, Field field) =>
      updateWithCatch(uuid, field);

  @ApiMethod(method: 'DELETE', path: '${ItemApi.fieldsPath}/{uuid}/')
  Future<VoidMessage> delete(String uuid) => deleteWithCatch(uuid);

  @override
  String generateRedirect(String newId) =>
      "${serverApiRoot}${ItemApi.fieldsPath}/${newId}";
}
