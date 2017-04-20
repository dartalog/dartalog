import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/data/templates/templates.dart' as templates;
import 'a_templating_model.dart';
import 'field_model.dart';
import 'package:option/option.dart';

class ItemTypeModel extends ATemplatingModel<ItemType> {
  static final Logger _log = new Logger('ItemTypeModel');
  @override
  Logger get loggerImpl => _log;

  @override
  AIdNameBasedDataSource<ItemType> get dataSource => itemTypeDataSource;

  @override
  UuidDataList<ItemType> get availableTemplates => templates.itemTypeTemplates;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.curator;

  final FieldModel fieldModel;
  final AFieldDataSource fieldDataSource;
  final AItemTypeDataSource itemTypeDataSource;

  ItemTypeModel(this.fieldModel, this.fieldDataSource, this.itemTypeDataSource, AUserDataSource userDataSource): super(userDataSource);

  @override
  Future<ItemType> getByUuid(String uuid,
      {bool includeFields: false, bool bypassAuthentication: false}) async {
    final ItemType output =
        await super.getByUuid(uuid, bypassAuthentication: bypassAuthentication);
    if (includeFields) {
      output.fields = await fieldDataSource.getByUuids(output.fieldUuids);
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
      final List<Field> test =
          await fieldDataSource.getByUuids(itemType.fieldUuids);
      if (test.length != itemType.fieldUuids.length)
        fieldErrors["fieldUuids"] = "Not found";
    }
  }

  @override
  Future<String> applyTemplate(String uuid) async {
    final Option<ItemType> templateOpt = availableTemplates.getByUuid(uuid);
    final ItemType template = templateOpt.getOrElse(() =>
        throw new NotFoundException("Item type template $uuid not found"));

    for (String fieldUuid in template.fieldUuids) {
      await fieldModel.applyTemplate(fieldUuid);
    }

    return super.applyTemplate(uuid);
  }
}
