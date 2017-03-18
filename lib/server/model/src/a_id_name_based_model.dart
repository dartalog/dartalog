import 'dart:async';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'a_typed_model.dart';
import 'package:meta/meta.dart';

abstract class AIdNameBasedModel<T extends AIdData> extends ATypedModel<T> {
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

  Future<String> delete(String id) async {
    final String normId = normalizeId(id);
    await validateDeletePrivileges(normId);
    await dataSource.deleteByID(normId);
    return normId;
  }

  Future<IdNameList<T>> getAll() async {
    await validateGetAllPrivileges();

    final List<T> output = await dataSource.getAll();
    for (T t in output) performAdjustments(t);
    return output;
  }

  Future<IdNameList<IdNamePair>> getAllIdsAndNames() async {
    await validateGetAllIdsAndNamesPrivileges();
    return await dataSource.getAllIdsAndNames();
  }

  Future<T> getById(String id, {bool bypassAuth: false}) async {
    final String normId = normalizeId(id);
    if (!bypassAuth) await validateGetByIdPrivileges();

    final Option<T> output = await dataSource.getById(normId);

    if (output.isEmpty) throw new NotFoundException("ID '$normId' not found");

    performAdjustments(output.get());

    return output.get();
  }

  Future<IdNameList<T>> search(String query) async {
    await validateSearchPrivileges();
    return await dataSource.search(query);
  }

  Future<String> update(String id, T t) async {
    final String normId = normalizeId(id);
    await validateUpdatePrivileges(normId);
    await validate(t, normId!= t.getId);
    return await dataSource.write(t, normId);
  }

  @protected
  void performAdjustments(T t) {}

  @override
  Future<Map<String, String>> validateFields(T t, bool creating) async {
    final Map<String, String> fieldErrors = new Map<String, String>();

    t.setId = normalizeId(t.getId);
    t.setName = t.getName.trim();

    if (StringTools.isNullOrWhitespace(t.getId))
      fieldErrors["id"] = "Required";
    else {
      if (creating) {
        if (await dataSource.existsByID(t.getId))
          fieldErrors["id"] = "Already in use";
      }
      if (isReservedWord(t.getId)) {
        fieldErrors["id"] = "Cannot use '${t.getId}' as ID";
      }
    }

    if (StringTools.isNullOrWhitespace(t.getName)) {
      fieldErrors["name"] = "Required";
    } else if (isReservedWord(t.getId)) {
      fieldErrors["name"] = "Cannot use '${t.getName}' as name";
    }

    await validateFieldsInternal(fieldErrors, t, creating);

    return fieldErrors;
  }

  @protected
  Future<Null> validateFieldsInternal(Map<String,String> fieldErrors, T t, bool creating) async =>
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
