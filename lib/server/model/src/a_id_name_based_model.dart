import 'dart:async';
import 'package:option/option.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'a_typed_model.dart';
import 'package:meta/meta.dart';
import 'a_uuid_based_model.dart';

abstract class AIdNameBasedModel<T extends AHumanFriendlyData>
    extends AUuidBasedModel<T> {

  @override
  AIdNameBasedDataSource<T> get dataSource;


  Future<UuidDataList<IdNamePair>> getAllIdsAndNames() async {
    await validateGetAllIdsAndNamesPrivileges();
    return await dataSource.getAllIdsAndNames();
  }

  Future<T> getByReadableId(String readableId, {bool bypassAuth: false}) async {
    if (!bypassAuth) await validateGetByIdPrivileges();

    final Option<T> output = await dataSource.getByReadableId(readableId);

    if (output.isEmpty) throw new NotFoundException("Readable ID '$readableId' not found");

    await performAdjustments(output.get());

    return output.get();
  }

  Future<T> getByUuidOrReadableId(String uuidOrReadableId) async {
    if(isUuid(uuidOrReadableId)) {
      return getByUuid(uuidOrReadableId);
    } else {
      return getByReadableId(uuidOrReadableId);
    }
  }


  @override
  Future<Map<String, String>> validateFields(T t,
      {String existingId: null}) async {
    final Map<String, String> fieldErrors = new Map<String, String>();

    t.name = t.name.trim();

    if (StringTools.isNullOrWhitespace(t.readableId))
      fieldErrors["readableId"] = "Required";
    else if(isUuid(t.readableId))
      fieldErrors["readableId"] = "Cannot be in the form of a uuid";
    else if (isReservedWord(t.readableId))
      fieldErrors["readableId"] ="Cannot use '${t.readableId}' as Readable ID";
    else if (t.readableId.contains(" ")) // TODO: Come up with more definitive rules for readable IDs
      fieldErrors["readableId"] ="Cannot use spaces in Readable ID";
    else {
      final Option<T> item = await dataSource.getByReadableId(t.readableId);

      if (StringTools.isNullOrWhitespace(existingId)) {
        // Creating
        if (item.isNotEmpty) fieldErrors["readableId"] = "Already in use";
      } else {
        // Updating
        if (item.isNotEmpty && item.first.uuid != existingId)
          fieldErrors["readableId"] = "Already in use";
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
  Future<Null> validateGetAllIdsAndNamesPrivileges() async {
    await validateGetPrivileges();
  }

}
