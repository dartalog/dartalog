part of api;

class ImportResource extends AResource {
  static final Logger _log = new Logger('ImportResource');
  Logger get _logger => _log;

  @ApiMethod(path: '${API_IMPORT_PATH}/{provider}/{id}')
  Future<ImportResult> import(String provider, String id) => _catchExceptionsAwait(() async  {
    return await model.import.import(provider, id);
  });

  @ApiMethod(path: '${API_IMPORT_PATH}/')
  Future<Map<String, List<String>>> listProviders() => _catchExceptionsAwait(() async {
      return {
        "providers": ["amazon", "themoviedb"]
      };
  });

  @ApiMethod(path: '${API_IMPORT_PATH}/{provider}/search/{query}')
  Future<SearchResults> search(String provider, String query,
      {int page: 0}) => _catchExceptionsAwait(() async {
    return await model.import.search(provider, query, page: page);
  });

}
