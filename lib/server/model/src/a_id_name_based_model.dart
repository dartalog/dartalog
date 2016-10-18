import 'dart:async';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'a_typed_model.dart';
import 'package:meta/meta.dart';

abstract class AIdNameBasedModel<T extends AIdData> extends ATypedModel {
  AIdNameBasedDataSource<T> get dataSource;

  @protected
  String normalizeId(String input) {
    String output = input.trim().toLowerCase();
    output = Uri.decodeQueryComponent(output);
    return output;
  }

  Future<String> create(T t) async {
    await validateCreatePrivileges();
    await validate(t, true);
    return await dataSource.write(t);
  }

  Future delete(String id) async {
    id = normalizeId(id);
    await validateDeletePrivileges(id);
    await dataSource.deleteByID(id);
  }

  Future<IdNameList<T>> getAll() async {
    await validateGetAllPrivileges();

    List<T> output = await dataSource.getAll();
    for (T t in output) performAdjustments(t);
    return output;
  }

  Future<IdNameList<IdNamePair>> getAllIdsAndNames() async {
    await validateGetAllIdsAndNamesPrivileges();
    return await dataSource.getAllIdsAndNames();
  }

  Future<T> getById(String id, {bool bypassAuth: false}) async {
    id = normalizeId(id);
    if (!bypassAuth) await validateGetByIdPrivileges();

    Option<T> output = await dataSource.getById(id);

    if (output.isEmpty) throw new NotFoundException("ID '${id}' not found");

    performAdjustments(output.get());

    return output.get();
  }

  Future<IdNameList<T>> search(String query) async {
    await validateSearchPrivileges();
    return await dataSource.search(query);
  }

  Future<String> update(String id, T t) async {
    id = normalizeId(id);
    await validateUpdatePrivileges(id);
    await validate(t, id != t.getId);
    return await dataSource.write(t, id);
  }

  @protected
  void performAdjustments(T t) {}

  @override
  Future<Map<String, String>> validateFields(T t, bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    t.getId = normalizeId(t.getId);
    t.getName = t.getName.trim();

    if (StringTools.isNullOrWhitespace(t.getId))
      field_errors["id"] = "Required";
    else {
      if (creating) {
        if (await dataSource.existsByID(t.getId))
          field_errors["id"] = "Already in use";
      }
      if (isReservedWord(t.getId)) {
        field_errors["id"] = "Cannot use '${t.getId}' as ID";
      }
    }

    if (StringTools.isNullOrWhitespace(t.getName)) {
      field_errors["name"] = "Required";
    } else if (isReservedWord(t.getId)) {
      field_errors["name"] = "Cannot use '${t.getName}' as name";
    }

    await validateFieldsInternal(field_errors, t, creating);

    return field_errors;
  }

  @protected
  Future validateFieldsInternal(Map field_errors, T t, bool creating) async =>
      {};

  @protected
  Future validateGetAllIdsAndNamesPrivileges() async {
    await validateGetPrivileges();
  }

  @protected
  Future validateGetAllPrivileges() async {
    await validateGetPrivileges();
  }

  @protected
  Future validateGetByIdPrivileges() async {
    await validateGetPrivileges();
  }

  @protected
  Future validateSearchPrivileges() async {
    await validateGetPrivileges();
  }
}
