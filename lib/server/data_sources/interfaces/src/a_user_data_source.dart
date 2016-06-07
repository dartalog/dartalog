part of data_sources.interfaces;

abstract class AUserDataSource extends AIdNameBasedDataSource<User> {
  static final Logger _log = new Logger('AUserDataSource');
}