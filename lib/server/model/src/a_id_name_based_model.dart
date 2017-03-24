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

  Future<String> create(T t, {bool bypassAuthentication: false}) async {
    if(!bypassAuthentication)
      await validateCreatePrivileges();

    await validate(t);

    t.setId = generateUuid();

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
    await validateUpdatePrivileges(id);
    await validate(t, existingId:  id);
    return await dataSource.write(t, id);
  }

  @protected
  void performAdjustments(T t) {}

  @override
  Future<Map<String, String>> validateFields(T t, {String existingId: null}) async {
    final Map<String, String> fieldErrors = new Map<String, String>();

    t.setReadableId = normalizeId(t.getReadableId);
    t.setName = t.getName.trim();

    if (StringTools.isNullOrWhitespace(t.getReadableId))
      fieldErrors["readableId"] = "Required";
    else {
      final Option<T> item = await dataSource.getByReadableId(t.getReadableId);

      if(StringTools.isNullOrWhitespace(existingId)) {
        // Creating
        if(item.isNotEmpty)
          fieldErrors["readableId"] = "Already in use";
      } else {
        // Updating
        if(item.isNotEmpty&&item.first.getId!=existingId)
          fieldErrors["readableId"] = "Already in use";
      }
      if (isReservedWord(t.getId)) {
        fieldErrors["readableId"] = "Cannot use '${t.getReadableId}' as Readable ID";
      }
    }

    if (StringTools.isNullOrWhitespace(t.getName)) {
      fieldErrors["name"] = "Required";
    } else if (isReservedWord(t.getId)) {
      fieldErrors["name"] = "Cannot use '${t.getName}' as name";
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
