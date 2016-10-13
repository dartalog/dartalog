import 'dart:io';

import 'package:logging/logging.dart';
import 'package:options_file/options_file.dart';

class SettingsModel {
  static final Logger _log = new Logger('SettingsModel');
  OptionsFile _optionsFile = null;

  SettingsModel() {
    try {
      _optionsFile = new OptionsFile('server.options');
    } on FileSystemException catch (e, st) {
      _log.info("server.options not found, using all default settings");
    }
  }
  String get mongoConnectionString => _getStringFromOptionFile(
      "mongo", "mongodb://localhost:27017/dartalog");

  String get movieDbApiKey => "";

  String get serverBindToAddress => _getStringFromOptionFile(
      "bind", InternetAddress.LOOPBACK_IP_V6.address);

  int get serverPort => _getIntFromOptionFile("port", 3278);

  int _getIntFromOptionFile(String option, int defaultValue) {
    if (_optionsFile != null) return _optionsFile.getInt(option, defaultValue);
    return defaultValue;
  }

  String _getStringFromOptionFile(String option, String defaultValue) {
    if (_optionsFile != null)
      return _optionsFile.getString(option, defaultValue);
    return defaultValue;
  }
}
