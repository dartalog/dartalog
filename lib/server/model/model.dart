library model;

import 'dart:async';

import 'package:logging/logging.dart';

import 'package:dart_orm/dart_orm.dart' as ORM;
import 'package:dart_orm_adapter_mysql/dart_orm_adapter_mysql.dart' as MySQL;
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

  static Future setUpDataAdapter() async {
    if(options==null) {
      options = new OptionsFile('dartalog.options');
    }
    String connection_string = 'mysql://$options.getString("mysql_user"):$options.getString("mysql_password")@$options.getString("mysql_host"):$options.getInt("mysql_port",3306)/$options.getString("mysql_db")';

    ORM.DBAdapter adapter = new MySQL.MySQLDBAdapter(connection_string);

    await adapter.connect();

    ORM.addAdapter('modelAdapter', adapter);
    ORM.setDefaultAdapter('modelAdapter');

    bool migrationResult = await ORM.Migrator.migrate();

    assert(migrationResult);
  }

}