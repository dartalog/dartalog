import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/server.dart';
import 'a_data_source.dart';

abstract class ASettingsDataSource extends ADataSource {
  static final Logger _log = new Logger('ASettingsModel');

  ASettingsDataSource();

  Future<Map<String, String>> getAll();
  Future<Field> get(Settings setting);

  Future<Null> write(Settings setting, String value);
}
