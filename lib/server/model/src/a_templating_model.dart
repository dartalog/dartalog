import 'package:dartalog/global.dart';
import 'dart:async';
import 'package:dartalog/server/data/data.dart';
import 'a_id_name_based_model.dart';
abstract class ATemplatingModel<T extends AHumanFriendlyData> extends AIdNameBasedModel<T> {
  List<T> get availableTemplates;

  Future<List<IdNamePair>> getAllTemplateIds() async {
    await validateGetAllPrivileges();
    return IdNamePair.convertList(availableTemplates);
  }

  Future<String> applyTemplate(String uuid) async {
    await validateCreatePrivileges();

    for(T template in availableTemplates) {
      if(template.uuid==uuid) {
        return await this.create(template, bypassAuthentication: true, keepUuid: true);
      }
    }

    throw new NotFoundException("Template $uuid not found");
  }
}