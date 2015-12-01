part of model;

abstract class _AModel {
  static final Logger _log = new Logger('_AModel');

  static const String _UUID_REPLACEMENT_STRING = "###";

  static OptionsFile _options;

  static OptionsFile get options {
    if (_options == null) {
      _log.info("Opening options file");
      _options = new OptionsFile('dartalog.options');
    }
    return _options;
  }

}