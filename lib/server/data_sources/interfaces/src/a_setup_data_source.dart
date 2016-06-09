part of data_sources.interfaces;

abstract class ASetupDataSource extends _ADataSource {
  static final Logger _log = new Logger('ASetupDataSource');

  Future<bool> isSetup();
  Future markAsSetup();

  Future<String> getVersion();
  Future setVersion(String version);
}