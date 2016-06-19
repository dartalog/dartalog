part of model;

class ImportModel extends AModel {
  static final Logger _log = new Logger('ImportModel');
  Logger get _logger => _log;

  @override
  String get _defaultReadPrivilegeRequirement => UserPrivilege.curator;


  Future<ImportResult> import(String provider, String id) async  {
    await _validateReadPrivilegeRequirement();
    AImportProvider importer = _getProvider(provider);
    return await importer.import(id);
  }

  Future<SearchResults> search(String provider, String query,
      {int page: 0}) async {
    await _validateReadPrivilegeRequirement();
    AImportProvider importer = _getProvider(provider);
    query = Uri.decodeFull(query);
    return await importer.search(query, page: page);
  }

  AImportProvider _getProvider(String provider) {
    switch (provider) {
      case "amazon":
        return new AmazonImportProvider();
      case "themoviedb":
        return new TheMovieDbImportProvider();
      default:
        throw new Exception("Unknown import provider");
    }
  }

}
