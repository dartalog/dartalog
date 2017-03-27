import 'dart:async';
import 'a_model.dart';
import 'package:logging/logging.dart';

import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data/templates/templates.dart';

class TemplateModel extends AModel {
  static final Logger _log = new Logger('TemplateModel');
  @override
  Logger get loggerImpl => _log;

  Future<List<Field>> getFieldTemplates() async {
    await validateGetPrivileges();
    return fieldTemplates;
  }

  Future<List<ItemType>> getItemTypes() async {
    await validateGetPrivileges();
    return itemTypeTemplates;
  }

  Future<Null> applyFieldTemplate(String id) async {}
}
