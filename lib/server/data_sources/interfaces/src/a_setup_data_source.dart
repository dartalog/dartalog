import 'dart:async';
import 'package:logging/logging.dart';
import 'a_data_source.dart';

abstract class ASetupDataSource extends ADataSource {
  static final Logger _log = new Logger('ASetupDataSource');

  Future<bool> isSetup();
  Future<Null> markAsSetup();

  Future<String> getVersion();
  Future<Null> setVersion(String version);
}
