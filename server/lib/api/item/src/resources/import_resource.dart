import 'dart:async';

import 'package:dartalog/api/api.dart';
import '../../item_api.dart';
import 'package:dartalog/import/import.dart';
import 'package:dartalog/model/model.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

class ImportResource extends AResource {
  static final Logger _log = new Logger('ImportResource');
  @override
  Logger get childLogger => _log;

  final ImportModel importModel;
  ImportResource(this.importModel);

  @ApiMethod(path: '${ItemApi.importPath}/{provider}/{id}')
  Future<ImportResult> import(String provider, String id) =>
      catchExceptionsAwait(() async {
        return await importModel.import(provider, id);
      });

  @ApiMethod(path: '${ItemApi.importPath}/')
  Future<Map<String, List<String>>> listProviders() =>
      catchExceptionsAwait(() async {
        return {
          "providers": ["amazon", "themoviedb"]
        };
      });

  @ApiMethod(path: '${ItemApi.importPath}/{provider}/search/{query}')
  Future<SearchResults> search(String provider, String query, {int page: 0}) =>
      catchExceptionsAwait(() async {
        return await importModel.search(provider, query, page: page);
      });
}
