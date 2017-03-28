import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import '../requests/password_change_request.dart';
import '../../item_api.dart';

class UserResource extends AIdNameResource<User> {
  static final Logger _log = new Logger('UserResource');

  @override
  model.AIdNameBasedModel<User> get idModel => model.users;

  @override
  Logger get childLogger => _log;

  @override
  @ApiMethod(method: 'POST', path: '${ItemApi.usersPath}/')
  Future<IdResponse> create(User user) => createWithCatch(user);

  @override
  @ApiMethod(path: '${ItemApi.usersPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @override
  @ApiMethod(path: '${ItemApi.usersPath}/{uuid}/')
  Future<User> getByUuid(String uuid) => getByUuidWithCatch(uuid);

  @ApiMethod(path: 'current_user/')
  Future<User> getMe() => catchExceptionsAwait(() async {
        return await model.users.getMe();
      });

  @override
  @ApiMethod(method: 'PUT', path: '${ItemApi.usersPath}/{uuid}/')
  Future<IdResponse> update(String uuid, User user) => updateWithCatch(uuid, user);

  @ApiMethod(method: 'PUT', path: '${ItemApi.usersPath}/{uuid}/password/')
  Future<VoidMessage> changePassword(String uuid, PasswordChangeRequest pcr) =>
      catchExceptionsAwait(() async {
        await model.users
            .changePassword(uuid, pcr.currentPassword, pcr.newPassword);
        return new VoidMessage();
      });

  @override
  @ApiMethod(method: 'DELETE', path: '${ItemApi.usersPath}/{uuid}/')
  Future<VoidMessage> delete(String uuid) => deleteWithCatch(uuid);

  @ApiMethod(method: 'GET', path: '${ItemApi.usersPath}/{uuid}/borrowed/')
  Future<List<IdNamePair>> getBorrowedItems(String uuid) {
    return null;
  }

  @override
  String generateRedirect(String newUuid) =>
      "$serverApiRoot${ItemApi.usersPath}/$newUuid";
}
