library model;

import 'dart:async';
import 'package:logging/logging.dart';

import 'package:connection_pool/connection_pool.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:options_file/options_file.dart';

import 'package:dartalog/tools.dart' as tools;
import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/server/api/api.dart' as api;

part 'src/_a_model.dart';
part 'src/a_field_model.dart';
part 'src/a_item_type_model.dart';
part 'src/a_item_model.dart';
// part 'src/settings_model.dart';

part 'src/mongo/_mongo_db_connection_pool.dart';
part 'src/mongo/_mongo_database.dart';
part 'src/mongo/_mongo_field_model.dart';
part 'src/mongo/_mongo_item_type_model.dart';
part 'src/mongo/_mongo_item_model.dart';



class Model {
  static final Logger _log = new Logger('Model');

  static AItemModel items = new _MongoItemModel();

  static AFieldModel fields = new _MongoFieldModel();

  static AItemTypeModel templates = new _MongoItemTypeModel();

  static OptionsFile get options {
    return _AModel.options;
  }
}
