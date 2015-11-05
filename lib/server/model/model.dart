library model;

import 'dart:async';
import 'package:rpc/rpc.dart';
import 'package:logging/logging.dart';

import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:options_file/options_file.dart';

import 'package:dartalog/tools.dart' as tools;
import 'package:dartalog/dartalog.dart' as dartalog;

part 'src/exceptions/validation_exception.dart';

part 'src/_a_model.dart';
part 'src/field_model.dart';
part 'src/template_model.dart';
// part 'src/settings_model.dart';

part 'src/data/a_data.dart';
part 'src/data/field.dart';
part 'src/data/template.dart';


class Model {
  static final Logger _log = new Logger('Model');

  static OptionsFile options;

  static mongo.Db _db;

  static Future<mongo.Db> setUpDataAdapter() async {
    if (options == null) {
      _log.info("Opening options file");
      options = new OptionsFile('dartalog.options');
    }

    if(Model._db==null) {
      _log.info("Opening database connection");
      _db = new mongo.Db(options.getString("mongo"));
      await _db.open();
    }
    if(_db.state==mongo.State.OPEN) {
      return _db;
    } else {
      throw new Exception("Database connection not open");
    }
  }
}
