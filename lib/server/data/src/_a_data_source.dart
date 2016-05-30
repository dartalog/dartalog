part of data;

abstract class _ADataSource {
  static final Logger _log = new Logger('_ADataSource');

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
