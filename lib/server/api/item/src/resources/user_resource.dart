import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';
import '../requests/password_change_request.dart';
import '../../item_api.dart';

class UserResource extends AIdResource<User> {
  static final Logger _log = new Logger('UserResource');
  model.AIdNameBasedModel<User> get idModel => model.users;

  @override
  Logger get childLogger => _log;

  @ApiMethod(method: 'POST', path: '${ItemApi.usersPath}/')
  Future<IdResponse> create(User user) => createWithCatch(user);

  @ApiMethod(path: '${ItemApi.usersPath}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @ApiMethod(path: '${ItemApi.usersPath}/{id}/')
  Future<User> getById(String id) => getByIdWithCatch(id);

  @ApiMethod(path: 'current_user/')
  Future<User> getMe() => catchExceptionsAwait(() async {
        return await model.users.getMe();
      });

  @ApiMethod(method: 'PUT', path: '${ItemApi.usersPath}/{id}/')
  Future<IdResponse> update(String id, User user) => updateWithCatch(id, user);

  @ApiMethod(method: 'PUT', path: '${ItemApi.usersPath}/{id}/password/')
  Future<VoidMessage> changePassword(String id, PasswordChangeRequest pcr) =>
      catchExceptionsAwait(() async {
        await model.users
            .changePassword(id, pcr.currentPassword, pcr.newPassword);
        return new VoidMessage();
      });

  @ApiMethod(method: 'DELETE', path: '${ItemApi.usersPath}/{id}/')
  Future<VoidMessage> delete(String id) => deleteWithCatch(id);

  @ApiMethod(method: 'GET', path: '${ItemApi.usersPath}/{id}/borrowed/')
  Future<List<IdNamePair>> getBorrowedItems();

  @override
  String generateRedirect(String newId) =>
      "${serverApiRoot}${ItemApi.usersPath}/${newId}";
}
