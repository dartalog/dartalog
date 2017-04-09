import 'dart:async';
import 'dart:io';

import 'package:dartalog/global.dart';
import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/server/data_sources/mongo/mongo.dart' as mongo;
import 'package:dartalog/server/model/model.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';

import 'a_model.dart';

class SetupModel extends AModel {
  static final Logger _log = new Logger('UserModel');

  bool _setupDisabled = false;

  @override
  Logger get loggerImpl => _log;

  Future<SetupResponse> apply(SetupRequest request) async {
    await _checkIfSetupEnabled();

    await DataValidationException
        .performValidation((Map<String, String> fieldErrors) async {
//      if(StringTools.isNotNullOrWhitespace(request.databaseConnectionString)) {
//        try {
//          await mongo.MongoDatabase.testConnectionString(
//              request.databaseConnectionString);
//
//          settings.mongoConnectionString = request.databaseConnectionString;
//          await mongo.MongoDatabase.closeAllConnections();
//        } catch (e,st) {
//          _log.severe("apply", e, st);
//          fieldErrors["databaseConnectionString"] = e.toString();
//        }
//
//      } else if(await checkDatabase()) {
//        fieldErrors["databaseConnectionString"] = "Required";
//      }

      if (StringTools.isNotNullOrWhitespace(request.adminUser)) {
        try {
          await users.createUserWith(request.adminUser, request.adminEmail,
              request.adminPassword, UserPrivilege.admin,
              bypassAuthentication: true);
        } on DataValidationException catch (e) {
          fieldErrors.addAll(e.fieldErrors);
        }
      } else if (await checkForAdminUsers()) {
        fieldErrors["adminUser"] = "Required";
      }
    });

    await new File(setupLockFilePath).create();

    return await checkSetup();
  }

  Future<bool> checkDatabase() async {
    return false;
  }

  Future<bool> checkForAdminUsers() async {
    await _checkIfSetupEnabled();
    final List<User> admins = await data_sources.users.getAdmins();
    return admins.isNotEmpty;
  }

  Future<SetupResponse> checkSetup() async {
    if (!await isSetupAvailable()) {
      throw new SetupDisabledException();
    }

    final SetupResponse output = new SetupResponse();

    output.adminUser = await checkForAdminUsers();

    return output;
  }

  void disableSetup() {
    _setupDisabled = true;
  }

  Future<bool> isSetupAvailable() async {
    if (_setupDisabled) return false;

    if (await new File(setupLockFilePath).exists()) {
      _setupDisabled = true;
      return false;
    }
    return true;
  }

  Future<Null> _checkIfSetupEnabled() async {
    if (!await isSetupAvailable()) {
      throw new SetupDisabledException();
    }
  }
}
