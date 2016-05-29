part of api;

class ImportResource extends AResource {
  static final Logger _log = new Logger('ImportResource');
  Logger get _logger => _log;

  @ApiMethod(path: '${API_IMPORT_PATH}/{provider}/{id}')
  Future<ImportResult> import(String provider, String id) async {
    try {
      AImportProvider importer = _getProvider(provider);
      return await importer.import(id);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_IMPORT_PATH}/')
  Future<Map<String, List<String>>> listProviders() async {
    try {
      return {
        "providers": ["amazon", "themoviedb"]
      };
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_IMPORT_PATH}/{provider}/search/{query}')
  Future<SearchResults> search(String provider, String query,
      {String template, int page: 0}) async {
    try {
      AImportProvider importer = _getProvider(provider);
      query = Uri.decodeFull(query);
      return await importer.search(query, template, page: page);
    } catch (e, st) {
      _HandleException(e, st);
    }
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
