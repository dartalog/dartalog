part of api;

class ImportResource extends AResource {
  static final Logger _log = new Logger('ImportResource');

  Logger _GetLogger() {
    return _log;
  }

  AImportProvider _getProvider(String provider) {
    switch(provider) {
      case "amazon":
        return new AmazonImportProvider();
      case "themoviedb":
        return new TheMovieDbImportProvider();
      default:
        throw new Exception("Unknown import provider");
    }
  }

  @ApiMethod(path: 'import/')
  Future<Map<String,List<String>>> listProviders() async {
    try {
      return { "providers": ["amazon", "themoviedb"]};

    } catch(e,st) {
      _HandleException(e, st);
    }
  }

//  @ApiMethod(path: 'import/{provider}')
//  Future<Map<String,List<String>>> listProviderSearchOptions(String provider) async {
//    try {
//      return { "search": ["query", "type"],
//                "import": ["import"]
//              };
//
//    } catch(e,st) {
//      _log.severe(e,st);
//      throw e;
//    }
//  }

  @ApiMethod(path: 'import/{provider}/search/{query}')
  Future<SearchResults> search(String provider, String query, {String template, int page: 0}) async {
    try {
      AImportProvider importer = _getProvider(provider);
      query = Uri.decodeFull(query);
      return await importer.search(query, template, page: page);
    } catch(e,st) {
      _HandleException (e, st);
    }
  }
//
//  @ApiMethod(path: 'import/{provider}/settings/')
//  Future<ImportSettings> getSettings(String provider) async {
//    try {
//      return
//      AImportProvider importer = _getProvider(provider);
//      query = Uri.decodeFull(query);
//      return await importer.search(query, template, page: page);
//    } catch(e,st) {
//      _HandleException(e, st);
//    }
//  }

  @ApiMethod(path: 'import/{provider}/{id}')
  Future<ImportResult> import(String provider, String id) async {
    try {
      AImportProvider importer = _getProvider(provider);
      return await importer.import(id);
    } catch(e,st) {
      _HandleException(e, st);
    }
  }

}