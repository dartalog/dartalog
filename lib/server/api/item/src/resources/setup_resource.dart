import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

class SetupResource extends AResource {
  static final Logger _log = new Logger('SetupResource');

  @override
  String get resourcePath => setupApiPath;

  @override
  Logger get childLogger => _log;

  @ApiMethod(method: 'PUT', path: '$setupApiPath/')
  Future<SetupResponse> apply(SetupRequest request) async {
    return catchExceptionsAwait(() async {
      return await model.setup.apply(request);
    });
  }

  @ApiMethod(method: 'GET', path: '$setupApiPath/')
  Future<SetupResponse> get() async {
    return catchExceptionsAwait(() async {
      return await model.setup.checkSetup();
    });
  }
}
