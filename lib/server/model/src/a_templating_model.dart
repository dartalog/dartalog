import 'package:dartalog/global.dart';
import 'dart:async';
import 'package:dartalog/server/data/data.dart';
import 'a_id_name_based_model.dart';
import 'package:option/option.dart';
import 'package:logging/logging.dart';

abstract class ATemplatingModel<T extends AHumanFriendlyData> extends AIdNameBasedModel<T> {
  static final Logger _log = new Logger('ATemplatingModel');

  UuidDataList<T> get availableTemplates;

  Future<List<IdNamePair>> getAllTemplateIds() async {
    await validateGetAllPrivileges();
    return IdNamePair.convertList(availableTemplates);
  }

  Future<String> applyTemplate(String uuid) async {
    await validateCreatePrivileges();

    if(!availableTemplates.containsUuid(uuid))
      throw new NotFoundException("Template $uuid not found");

    final T template = availableTemplates.getByUuid(uuid).first;

    if(await dataSource.existsByUuid(uuid)) {
      return await this.update(uuid, template, bypassAuthentication: true);
    } else {
      return await this.create(template, bypassAuthentication: true, keepUuid: true);
    }

  }
}