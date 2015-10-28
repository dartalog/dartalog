library model;

import 'dart:async';

import 'package:logging/logging.dart';

import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:options_file/options_file.dart';

import 'package:dartalog/dartalog.dart';

part 'src/exceptions/validation_exception.dart';

part 'src/_a_model.dart';
part 'src/field_model.dart';
part 'src/template_model.dart';
// part 'src/settings_model.dart';

part 'src/data/field.dart';
part 'src/data/template.dart';


class Model {
  static OptionsFile options;

  static mongo.Db _db;

  static Future<mongo.Db> setUpDataAdapter() async {
    if (options == null) {
      options = new OptionsFile('dartalog.options');
    }

    _db = new mongo.Db(options.getString("mongo"));
    await _db.open();
    return _db;
  }
}
