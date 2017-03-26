import 'dart:async';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'a_typed_model.dart';
import 'package:meta/meta.dart';

abstract class AIdNameBasedModel<T extends AHumanFriendlyData> extends ATypedModel<T> {
  AIdNameBasedDataSource<T> get dataSource;

  @protected
  String normalizeId(String input) {
    String output = input.trim().toLowerCase();
    output = Uri.decodeQueryComponent(output);
    return output;
  }

  Future<String> create(T t, {bool bypassAuthentication: false}) async {
    if(!bypassAuthentication)
      await validateCreatePrivileges();

    await validate(t);

    t.uuid = generateUuid();

    return await dataSource.write(t);
  }

  Future<String> delete(String uuid) async {
    await validateDeletePrivileges(uuid);
    await dataSource.deleteByID(uuid);
    return uuid;
  }

  Future<UuidDataList<T>> getAll() async {
    await validateGetAllPrivileges();

    final List<T> output = await dataSource.getAll();
    for (T t in output) performAdjustments(t);
    return output;
  }

  Future<UuidDataList<IdNamePair>> getAllIdsAndNames() async {
    await validateGetAllIdsAndNamesPrivileges();
    return await dataSource.getAllIdsAndNames();
  }

  Future<T> getByUuid(String uuid, {bool bypassAuth: false}) async {
    if (!bypassAuth) await validateGetByIdPrivileges();

    final Option<T> output = await dataSource.getById(uuid);

    if (output.isEmpty) throw new NotFoundException("UUID '$uuid' not found");

    performAdjustments(output.get());

    return output.get();
  }

  Future<UuidDataList<T>> search(String query) async {
    await validateSearchPrivileges();
    return await dataSource.search(query);
  }

  Future<String> update(String uuid, T t) async {
    await validateUpdatePrivileges(uuid);
    await validate(t, existingId:  uuid);
    return await dataSource.write(t, uuid);
  }

  @protected
  void performAdjustments(T t) {}

  @override
  Future<Map<String, String>> validateFields(T t, {String existingId: null}) async {
    final Map<String, String> fieldErrors = new Map<String, String>();

    t.readableId = normalizeId(t.readableId);
    t.name = t.name.trim();

    if (StringTools.isNullOrWhitespace(t.readableId))
      fieldErrors["readableId"] = "Required";
    else {
      final Option<T> item = await dataSource.getByReadableId(t.readableId);

      if(StringTools.isNullOrWhitespace(existingId)) {
        // Creating
        if(item.isNotEmpty)
          fieldErrors["readableId"] = "Already in use";
      } else {
        // Updating
        if(item.isNotEmpty&&item.first.uuid!=existingId)
          fieldErrors["readableId"] = "Already in use";
      }
      if (isReservedWord(t.readableId)) {
        fieldErrors["readableId"] = "Cannot use '${t.readableId}' as Readable ID";
      }
    }

    if (StringTools.isNullOrWhitespace(t.name)) {
      fieldErrors["name"] = "Required";
    } else if (isReservedWord(t.name)) {
      fieldErrors["name"] = "Cannot use '${t.name}' as name";
    }

    await validateFieldsInternal(fieldErrors, t, existingId: existingId);

    return fieldErrors;
  }

  @protected
  Future<Null> validateFieldsInternal(Map<String,String> fieldErrors, T t, {String existingId: null}) async =>
      {};

  @protected
  Future<Null> validateGetAllIdsAndNamesPrivileges() async {
    await validateGetPrivileges();
  }

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
