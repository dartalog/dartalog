import 'dart:async';
import 'package:logging/logging.dart';
import 'a_data_source.dart';

abstract class ASetupDataSource extends ADataSource {
  static final Logger _log = new Logger('ASetupDataSource');

  Future<bool> isSetup();
  Future markAsSetup();

  Future<String> getVersion();
  Future setVersion(String version);
}