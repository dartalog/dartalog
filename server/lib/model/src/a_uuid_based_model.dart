import 'dart:async';
import 'package:option/option.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';
import 'a_typed_model.dart';
import 'package:meta/meta.dart';

abstract class AUuidBasedModel<T extends AUuidData> extends ATypedModel<T> {
  AUuidBasedDataSource<T> get dataSource;

  AUuidBasedModel(AUserDataSource userDataSource): super(userDataSource);

  Future<String> create(T t,
      {bool bypassAuthentication: false, bool keepUuid: false}) async {
    if (!bypassAuthentication) await validateCreatePrivileges();
    await validate(t);
    if (!keepUuid) t.uuid = generateUuid();
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
    if (output.isEmpty)
      throw new NotFoundException(
          "UUID '$uuid' not found (${this.runtimeType.toString()})");
    await performAdjustments(output.get());
    return output.get();
  }

  Future<UuidDataList<T>> search(String query) async {
    await validateSearchPrivileges();
    return await dataSource.search(query);
  }

  Future<String> update(String uuid, T t,
      {bool bypassAuthentication: false}) async {
    if (!bypassAuthentication) await validateUpdatePrivileges(uuid);

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
