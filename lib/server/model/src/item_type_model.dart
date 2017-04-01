import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/server/data/templates/templates.dart' as templates;
import '../model.dart' as model;
import 'a_templating_model.dart';
import 'package:option/option.dart';

class ItemTypeModel extends ATemplatingModel<ItemType> {
  static final Logger _log = new Logger('ItemTypeModel');
  @override
  Logger get loggerImpl => _log;

  @override
  AIdNameBasedDataSource<ItemType> get dataSource => data_sources.itemTypes;

  @override
  UuidDataList<ItemType> get availableTemplates => templates.itemTypeTemplates;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.curator;

  @override
  Future<ItemType> getByUuid(String uuid,
      {bool includeFields: false, bool bypassAuthentication: false}) async {
    final ItemType output = await super.getByUuid(uuid, bypassAuthentication: bypassAuthentication);
    if (includeFields) {
      output.fields = await data_sources.fields.getByUuids(output.fieldUuids);
    }
    return output;
  }

  @override
  Future<Null> validateFieldsInternal(
      Map<String, String> fieldErrors, ItemType itemType,
      {String existingId: null}) async {
    if (itemType.fieldUuids == null || itemType.fieldUuids.length == 0)
      fieldErrors["fieldUuids"] = "Required";
    else {
      final List<Field> test = await data_sources.fields.getByUuids(itemType.fieldUuids);
      if (test.length != itemType.fieldUuids.length)
        fieldErrors["fieldUuids"] = "Not found";
    }
  }

  @override
  Future<String> applyTemplate(String uuid) async {
    final Option<ItemType> templateOpt = availableTemplates.getByUuid(uuid);
    final ItemType template = templateOpt.getOrElse(() => throw new NotFoundException("Item type template $uuid not found"));

    for(String fieldUuid in template.fieldUuids) {
      await model.fields.applyTemplate(fieldUuid);
    }

    return super.applyTemplate(uuid);
  }
}
