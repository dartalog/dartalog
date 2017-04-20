import 'package:dartalog_shared/global.dart';
import 'dart:async';
import 'package:dartalog/data/data.dart';
import 'a_id_name_based_model.dart';
import 'package:option/option.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/data_sources/data_sources.dart';

abstract class ATemplatingModel<T extends AHumanFriendlyData>
    extends AIdNameBasedModel<T> {
  static final Logger _log = new Logger('ATemplatingModel');

  ATemplatingModel(AUserDataSource userDataSource): super(userDataSource);

  UuidDataList<T> get availableTemplates;

  Future<List<IdNamePair>> getAllTemplateIds() async {
    await validateGetAllPrivileges();
    return IdNamePair.convertList(availableTemplates);
  }

  Future<String> applyTemplate(String uuid) async {
    await validateCreatePrivileges();

    if (!availableTemplates.containsUuid(uuid))
      throw new NotFoundException("Template $uuid not found");

    final T template = availableTemplates.getByUuid(uuid).first;

    if (await dataSource.existsByUuid(uuid)) {
      return await this.update(uuid, template, bypassAuthentication: true);
    } else {
      return await this
          .create(template, bypassAuthentication: true, keepUuid: true);
    }
  }
}
