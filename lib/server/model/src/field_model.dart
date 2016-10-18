import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';

class FieldModel extends AIdNameBasedModel<Field> {
  static final Logger _log = new Logger('FieldModel');
  @override
  Logger get childLogger => _log;
  AIdNameBasedDataSource<Field> get dataSource => data_sources.fields;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.curator;

  @override
  Future validateFieldsInternal(
      Map field_errors, Field field, bool creating) async {
    if (StringTools.isNullOrWhitespace(field.type))
      field_errors["type"] = "Required";
    else if (!FIELD_TYPES.containsKey(field.type)) {
      field_errors["type"] = "Invalid";
    }

    if (!StringTools.isNullOrWhitespace(field.format)) {
      String test = validateRegularExpression(field.format);
      if (!StringTools.isNullOrWhitespace(test)) field_errors["format"] = test;
    }
  }
}
