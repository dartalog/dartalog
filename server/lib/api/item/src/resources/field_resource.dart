import 'dart:async';

import 'package:dartalog/api/api.dart';
import 'package:dartalog/api/item/item_api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

class FieldResource extends AIdNameResource<Field> {
  static final Logger _log = new Logger('FieldResource');

  @override
  AIdNameBasedModel<Field> get idModel => fieldModel;

  final FieldModel fieldModel;

  FieldResource(this.fieldModel);

  @override
  Logger get childLogger => _log;

  @override
  @ApiMethod(method: 'POST', path: '${ItemApi.fieldsPath}/')
  Future<IdResponse> create(Field field) => createWithCatch(field);

  @override
  @ApiMethod(path: '${ItemApi.fieldsPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @override
  @ApiMethod(path: '${ItemApi.fieldsPath}/{uuid}/')
  Future<Field> getByUuid(String uuid) => getByUuidWithCatch(uuid);

  @override
  @ApiMethod(method: 'PUT', path: '${ItemApi.fieldsPath}/{uuid}/')
  Future<IdResponse> update(String uuid, Field field) =>
      updateWithCatch(uuid, field);

  @override
  @ApiMethod(method: 'DELETE', path: '${ItemApi.fieldsPath}/{uuid}/')
  Future<VoidMessage> delete(String uuid) => deleteWithCatch(uuid);

  @override
  String generateRedirect(String newUuid) =>
      "$serverApiRoot${ItemApi.fieldsPath}/$newUuid";

  @ApiMethod(path: '${ItemApi.templatesPath}/${ItemApi.fieldsPath}/')
  Future<List<IdNamePair>> getAllTemplates() =>
      fieldModel.getAllTemplateIds();

  @ApiMethod(
      method: 'PUT', path: '${ItemApi.templatesPath}/${ItemApi.fieldsPath}/')
  Future<IdResponse> applyTemplate(IdRequest uuid) async =>
      new IdResponse.fromId(
          await fieldModel.applyTemplate(uuid.id), generateRedirect(uuid.id));
}
