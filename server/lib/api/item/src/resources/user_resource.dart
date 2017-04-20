import 'dart:async';

import 'package:dartalog/api/api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import '../requests/password_change_request.dart';
import '../../item_api.dart';

class UserResource extends AIdNameResource<User> {
  static final Logger _log = new Logger('UserResource');

  @override
  AIdNameBasedModel<User> get idModel => userModel;
  final UserModel userModel;

  UserResource(this.userModel);

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
        return await userModel.getMe();
      });

  @override
  @ApiMethod(method: 'PUT', path: '${ItemApi.usersPath}/{uuid}/')
  Future<IdResponse> update(String uuid, User user) =>
      updateWithCatch(uuid, user);

  @ApiMethod(method: 'PUT', path: '${ItemApi.usersPath}/{uuid}/password/')
  Future<VoidMessage> changePassword(String uuid, PasswordChangeRequest pcr) =>
      catchExceptionsAwait(() async {
        await userModel
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
