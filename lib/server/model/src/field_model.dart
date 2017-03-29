import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';
import 'package:dartalog/server/data/templates/templates.dart' as templates;
import 'a_templating_model.dart';

class FieldModel extends ATemplatingModel<Field> {
  static final Logger _log = new Logger('FieldModel');
  @override
  Logger get loggerImpl => _log;
  @override
  AIdNameBasedDataSource<Field> get dataSource => data_sources.fields;

  @override
  List<Field> get availableTemplates => templates.fieldTemplates;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.curator;

  @override
  Future<Null> validateFieldsInternal(
      final Map<String, String> fieldErrors, Field field,
      {String existingId: null}) async {
    if (StringTools.isNullOrWhitespace(field.type))
      fieldErrors["type"] = "Required";
    else if (!globalFieldTypes.containsKey(field.type)) {
      fieldErrors["type"] = "Invalid";
    }

    if (!StringTools.isNullOrWhitespace(field.format)) {
      final String test = validateRegularExpression(field.format);
      if (!StringTools.isNullOrWhitespace(test)) fieldErrors["format"] = test;
    }
  }

  @override
  Future<String> delete(String id) async {
    throw new Exception("Not implemented");
  }

}
