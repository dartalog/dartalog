import 'dart:async';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'a_typed_model.dart';
import 'package:meta/meta.dart';

abstract class AUuidBasedModel<T extends AUuidData>
    extends ATypedModel<T> {
  AUuidBasedDataSource<T> get dataSource;

  Future<String> create(T t, {bool bypassAuthentication: false}) async {
    if (!bypassAuthentication) await validateCreatePrivileges();
    await validate(t);
    t.uuid = generateUuid();
    return await dataSource.create(t.uuid, t);
  }

  Future<String> delete(String uuid) async {
    await validateDeletePrivileges(uuid);
    await dataSource.deleteByUuid(uuid);
    return uuid;
  }

  Future<UuidDataList<T>> getAll() async {
    await validateGetAllPrivileges();

    final List<T> output = await dataSource.getAll();
    for (T t in output) await performAdjustments(t);
    return output;
  }

  Future<T> getByUuid(String uuid, {bool bypassAuthentication: false}) async {
    if (!bypassAuthentication) await validateGetByIdPrivileges();

    final Option<T> output = await dataSource.getByUuid(uuid);

    if (output.isEmpty) throw new NotFoundException("UUID '$uuid' not found");

    await performAdjustments(output.get());

    return output.get();
  }


  Future<UuidDataList<T>> search(String query) async {
    await validateSearchPrivileges();
    return await dataSource.search(query);
  }

  Future<String> update(String uuid, T t) async {
    await validateUpdatePrivileges(uuid);
    await validate(t, existingId: uuid);
    return await dataSource.update(uuid, t);
  }

  @protected
  Future<Null> performAdjustments(T t) async {}

  @protected
  Future<Null> validateFieldsInternal(Map<String, String> fieldErrors, T t,
          {String existingId: null}) async {}

  @protected
  Future<Null> validateGetAllPrivileges() async {
    await validateGetPrivileges();
  }

  @protected
  Future<Null> validateGetByIdPrivileges() async {
    await validateGetPrivileges();
  }

  @protected
  Future<Null> validateSearchPrivileges() async {
    await validateGetPrivileges();
  }
}
