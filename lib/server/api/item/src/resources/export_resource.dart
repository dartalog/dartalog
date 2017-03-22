import 'dart:async';

import 'package:dartalog/global.dart';
import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import '../../item_api.dart';
import 'item_copy_resource.dart';

class ExportResource extends AResource {
  static final Logger _log = new Logger('ExportResource');
  @override
  Logger get childLogger => _log;

  static const String _apiPath= ItemApi.exportPath;


  @ApiMethod(path: '${ItemApi.exportPath}/collections/')
  Future<List<Collection>> exportCollections() =>catchExceptionsAwait(() async {
    return await model.export.exportCollections();
  });



}
