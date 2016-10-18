import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/api/responses/responses.dart';
import 'package:dartalog/server/api/requests/requests.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import '../requests/database_setup_request.dart';
import 'a_resource.dart';

class SetupResource extends AResource {
  static final Logger _log = new Logger('SetupResource');

  @override
  Logger get childLogger => _log;

  @ApiMethod(path: '${API_SETUP_PATH}/database/')
  Future<List<String>> checkDatabase() async {
    return catchExceptionsAwait(() async {
      await model.setup.checkDatabase();
      return ["Datebase is configured correctly"];
    });
  }

  @ApiMethod(method: 'POST', path: '${API_SETUP_PATH}/database/')
  Future<VoidMessage> setUpDatabase(DatabaseSetupRequest request) async {
    return catchExceptionsAwait(() async {
      await model.setup.setDatabase();
      return new VoidMessage();
    });
  }

  @ApiMethod(path: '${API_SETUP_PATH}/admin_user/')
  Future<List<String>> checkForAdminUser() async {
    return catchExceptionsAwait(() async {
      return await model.setup.checkForAdminUsers();
    });
  }

  @ApiMethod(method: 'POST', path: '${API_SETUP_PATH}/admin_user/')
  Future<IdResponse> createAdminUser(User request) async {
    return catchExceptionsAwait(() async {
      String id = await model.setup.createAdminUser(request);
      return new IdResponse.fromId(id);
    });
  }
}
