import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/import/import.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import 'a_resource.dart';

class ImportResource extends AResource {
  static final Logger _log = new Logger('ImportResource');
  @override
  Logger get childLogger => _log;

  @ApiMethod(path: '${API_IMPORT_PATH}/{provider}/{id}')
  Future<ImportResult> import(String provider, String id) => catchExceptionsAwait(() async  {
    return await model.import.import(provider, id);
  });

  @ApiMethod(path: '${API_IMPORT_PATH}/')
  Future<Map<String, List<String>>> listProviders() => catchExceptionsAwait(() async {
      return {
        "providers": ["amazon", "themoviedb"]
      };
  });

  @ApiMethod(path: '${API_IMPORT_PATH}/{provider}/search/{query}')
  Future<SearchResults> search(String provider, String query,
      {int page: 0}) => catchExceptionsAwait(() async {
    return await model.import.search(provider, query, page: page);
  });

}
