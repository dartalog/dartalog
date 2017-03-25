import 'package:logging/logging.dart';
import 'package:dartalog/tools.dart';
abstract class AErrorThing {
  Logger get loggerImpl;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  set errorMessage(String message) {
    _errorMessage = message;
    if(StringTools.isNotNullOrWhitespace(message))
      loggerImpl.severe("Error message set: " + message);
  }

  void setErrorMessage(Object e, StackTrace st) {
    loggerImpl.severe(e, st);
    _errorMessage = e.toString();
  }
}