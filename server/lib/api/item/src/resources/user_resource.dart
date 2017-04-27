import 'dart:async';

import 'package:dartalog/api/api.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import '../../item_api.dart';
import '../requests/password_change_request.dart';

class UserResource extends AIdNameResource<User> {
  static final Logger _log = new Logger('UserResource');

  final UserModel _userModel;
  UserResource(this._userModel);

  @override
  Logger get childLogger => _log;

  @override
  AIdNameBasedModel<User> get idModel => _userModel;

  @ApiMethod(method: 'PUT', path: '${ItemApi.usersPath}/{uuid}/password/')
  Future<VoidMessage> changePassword(String uuid, PasswordChangeRequest pcr) =>
      catchExceptionsAwait(() async {
        await _userModel.changePassword(
            uuid, pcr.currentPassword, pcr.newPassword);
        return new VoidMessage();
      });

  @override
  @ApiMethod(method: 'POST', path: '${ItemApi.usersPath}/')
  Future<IdResponse> create(User user) => createWithCatch(user);

  @override
  @ApiMethod(method: 'DELETE', path: '${ItemApi.usersPath}/{uuid}/')
  Future<VoidMessage> delete(String uuid) => deleteWithCatch(uuid);

  @override
  String generateRedirect(String newUuid) =>
      "$serverApiRoot${ItemApi.usersPath}/$newUuid";

  @override
  @ApiMethod(path: '${ItemApi.usersPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @ApiMethod(method: 'GET', path: '${ItemApi.usersPath}/{uuid}/borrowed/')
  Future<List<IdNamePair>> getBorrowedItems(String uuid) {
    return null;
  }

  @override
  @ApiMethod(path: '${ItemApi.usersPath}/{uuid}/')
  Future<User> getByUuid(String uuid) => getByUuidWithCatch(uuid);

  @ApiMethod(path: 'current_user/')
  Future<User> getMe() => catchExceptionsAwait(() => _userModel.getMe());

  @override
  @ApiMethod(method: 'PUT', path: '${ItemApi.usersPath}/{uuid}/')
  Future<IdResponse> update(String uuid, User user) =>
      updateWithCatch(uuid, user);
}
