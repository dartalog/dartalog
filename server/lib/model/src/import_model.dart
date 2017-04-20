import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/import/import.dart';
import 'a_model.dart';
import 'package:dartalog/data_sources/data_sources.dart';

class ImportModel extends AModel {
  static final Logger _log = new Logger('ImportModel');

  final AItemTypeDataSource itemTypeDataSource;

  ImportModel(this.itemTypeDataSource, AUserDataSource userDataSource): super(userDataSource);

  @override
  Logger get loggerImpl => _log;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.curator;

  Future<Map<String, String>> getAvailableImportProviders() async {
    await validateReadPrivilegeRequirement();

    final Map<String, String> output = new Map<String, String>();

    output[ImportProvider.amazon] = "Amazon";

    //output[ImportProvider.MOVIEDB] = "The MovieDB";

    return output;
  }

  Future<ImportResult> import(String provider, String id) async {
    await validateReadPrivilegeRequirement();
    final AImportProvider importer = ImportProvider.getProvider(provider,itemTypeDataSource);
    return await importer.import(id);
  }

  Future<SearchResults> search(String provider, String query,
      {int page: 0}) async {
    await validateReadPrivilegeRequirement();
    final AImportProvider importer = ImportProvider.getProvider(provider, itemTypeDataSource);
    query = Uri.decodeFull(query);
    return await importer.search(query, page: page);
  }
}
