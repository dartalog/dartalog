library model;

import 'dart:async';

import 'package:logging/logging.dart';

//import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:sqljocky/sqljocky.dart' as mysql;
//import 'package:server/database/database.dart';
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
  static mysql.ConnectionPool _pool;

  static OptionsFile options;

  static void initializeConnectionPool() {
    if(options==null) {
      options = new OptionsFile('dartalog.options');
    }
    _pool = new mysql.ConnectionPool(host: options.getString("mysql_host"), port: options.getInt("mysql_port",3306),
    user:options.getString("mysql_user"),password: options.getString("mysql_password"), db: options.getString("mysql_db"), max: 5);
  }

  static mysql.ConnectionPool getConnectionPool() {
    if(_pool==null) {
      initializeConnectionPool();
    }
    return _pool;
  }

}