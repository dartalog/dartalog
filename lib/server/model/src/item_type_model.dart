import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';

class ItemTypeModel extends AIdNameBasedModel<ItemType> {
  static final Logger _log = new Logger('ItemTypeModel');
  @override
  Logger get childLogger => _log;
  AIdNameBasedDataSource<ItemType> get dataSource => data_sources.itemTypes;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.curator;

  @override
  Future<ItemType> getById(String id, {bool includeFields: false, bool bypassAuth: false}) async {
    ItemType output = await super.getById(id, bypassAuth: bypassAuth);
    if(includeFields) {
      output.fields = await data_sources.fields.getByIds(output.fieldIds);
    }
    return output;
  }

  @override
  Future validateFieldsInternal(Map<String, String> field_errors, ItemType itemType, bool creating) async {
    if (itemType.fieldIds == null || itemType.fieldIds.length == 0)
      field_errors["fieldIds"] = "Required";
    else {
      List test = await data_sources.fields.getByIds(itemType.fieldIds);
      if(test.length!=itemType.fieldIds.length)
        field_errors["fieldIds"] = "Not found";
    }
  }

}