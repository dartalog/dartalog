part of model;

class ImportModel extends AModel {
  static final Logger _log = new Logger('ImportModel');
  Logger get _logger => _log;

  @override
  String get _defaultReadPrivilegeRequirement => UserPrivilege.curator;

  Future<Map<String,String>> getAvailableImportProviders() async {
    await _validateReadPrivilegeRequirement();

    Map<String,String> output = new Map<String,String>();

    output[ImportProvider.AMAZON] = "Amazon";
    output[ImportProvider.AMAZON] = "Amazon";

    //output[ImportProvider.MOVIEDB] = "The MovieDB";

    return output;
  }

  Future<ImportResult> import(String provider, String id) async  {
    await _validateReadPrivilegeRequirement();
    AImportProvider importer = ImportProvider.getProvider(provider);
    return await importer.import(id);
  }

  Future<SearchResults> search(String provider, String query,
      {int page: 0}) async {
    await _validateReadPrivilegeRequirement();
    AImportProvider importer = ImportProvider.getProvider(provider);
    query = Uri.decodeFull(query);
    return await importer.search(query, page: page);
  }



}
