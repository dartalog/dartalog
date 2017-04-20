import 'dart:async';

import 'package:dartalog_shared/global.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import '../../item_api.dart';
import 'item_copy_resource.dart';

class ExportResource extends AResource {
  static final Logger _log = new Logger('ExportResource');
  @override
  Logger get childLogger => _log;

  static const String _apiPath = ItemApi.exportPath;

  final ExportModel exportModel;

  ExportResource(this.exportModel);

  @ApiMethod(path: '${ItemApi.exportPath}/collections/')
  Future<List<Collection>> exportCollections() =>
      catchExceptionsAwait(() async {
        return await exportModel.exportCollections();
      });
}
