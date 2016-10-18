import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import '../../item_api.dart';
import 'package:dartalog/server/import/import.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

class ImportResource extends AResource {
  static final Logger _log = new Logger('ImportResource');
  @override
  Logger get childLogger => _log;

  @ApiMethod(path: '${ItemApi.importPath}/{provider}/{id}')
  Future<ImportResult> import(String provider, String id) =>
      catchExceptionsAwait(() async {
        return await model.import.import(provider, id);
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
        return await model.import.search(provider, query, page: page);
      });
}
