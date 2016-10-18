import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/server/model/model.dart';
import 'a_model.dart';

class SetupModel extends AModel {
  static final Logger _log = new Logger('UserModel');

  @override
  Logger get childLogger => _log;

  Future _checkIfSetupRequired() async {
    if (!await isSetupRequired()) {
      throw new SetupDisabledException();
    }
  }

  Future<List<String>> checkForAdminUsers() async {
    await _checkIfSetupRequired();
    List<User> admins = await data_sources.users.getAdmins();
    if (admins.length == 0) throw new Exception("");
  }

  Future<bool> checkDatabase() async {
    return false;
  }

  Future<bool> isSetupRequired() async {
    if (await new File(setupLockFilePath).exists()) {
      return false;
    }
    return true;
  }

  Future markAsSetup() async {
    if (!await checkDatabase()) {
      throw new InvalidInputException("Please complete database setup");
    }
    if ((await checkForAdminUsers()).length == 0) {
      throw new InvalidInputException("Please set up at least one user");
    }
    await new File(setupLockFilePath).create();
  }

  Future setDatabase() async {
    await _checkIfSetupRequired();
  }

  Future createAdminUser(User user) async {
    await _checkIfSetupRequired();

    user.type = UserPrivilege.admin;
    await users.create(user);
  }
}
