part of api;

class ImportResource extends AResource {
  static final Logger _log = new Logger('ImportResource');
  Logger get _logger => _log;

  @ApiMethod(path: '${API_IMPORT_PATH}/{provider}/{id}')
  Future<ImportResult> import(String provider, String id) => _catchExceptions(_import(provider, id));
  Future<ImportResult> _import(String provider, String id) async {
      AImportProvider importer = _getProvider(provider);
      return await importer.import(id);
  }

  @ApiMethod(path: '${API_IMPORT_PATH}/')
  Future<Map<String, List<String>>> listProviders() => _catchExceptions(_listProviders());
  Future<Map<String, List<String>>> _listProviders() async {
      return {
        "providers": ["amazon", "themoviedb"]
      };
  }

  @ApiMethod(path: '${API_IMPORT_PATH}/{provider}/search/{query}')
  Future<SearchResults> search(String provider, String query,
      {String template, int page: 0}) => _catchExceptions(_search(provider, query, template: template, page: page));
    Future<SearchResults> _search(String provider, String query,
      {String template, int page: 0}) async {
      AImportProvider importer = _getProvider(provider);
      query = Uri.decodeFull(query);
      return await importer.search(query, template, page: page);
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
