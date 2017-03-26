import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/import/import.dart';
import 'a_model.dart';

class ImportModel extends AModel {
  static final Logger _log = new Logger('ImportModel');
  @override
  Logger get loggerImpl => _log;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.curator;

  Future<Map<String, String>> getAvailableImportProviders() async {
    await validateReadPrivilegeRequirement();

    final Map<String, String> output = new Map<String, String>();

    output[ImportProvider.AMAZON] = "Amazon";
    output[ImportProvider.AMAZON] = "Amazon";

    //output[ImportProvider.MOVIEDB] = "The MovieDB";

    return output;
  }

  Future<ImportResult> import(String provider, String id) async {
    await validateReadPrivilegeRequirement();
    AImportProvider importer = ImportProvider.getProvider(provider);
    return await importer.import(id);
  }

  Future<SearchResults> search(String provider, String query,
      {int page: 0}) async {
    await validateReadPrivilegeRequirement();
    AImportProvider importer = ImportProvider.getProvider(provider);
    query = Uri.decodeFull(query);
    return await importer.search(query, page: page);
  }
}
