import 'dart:async';

import 'package:dartalog/server/api/api.dart';
import 'package:dartalog/server/api/responses/responses.dart';
import 'package:dartalog/server/api/requests/requests.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import 'a_id_resource.dart';

class UserResource extends AIdResource<User> {
  static final Logger _log = new Logger('UserResource');
  model.AIdNameBasedModel<User> get idModel => model.users;

  @override
  Logger get childLogger => _log;

  @ApiMethod(method: 'POST', path: '${API_USERS_PATH}/')
  Future<IdResponse> create(User user) => createWithCatch(user);

  @ApiMethod(path: '${API_USERS_PATH}/')
  Future<List<IdNamePair>> getAllIdsAndNames() => getAllIdsAndNamesWithCatch();

  @ApiMethod(path: '${API_USERS_PATH}/{id}/')
  Future<User> getById(String id) => getByIdWithCatch(id);

  @ApiMethod(path: 'current_user/')
  Future<User> getMe() => catchExceptionsAwait(() async {
    return await model.users.getMe();
  });


  @ApiMethod(method: 'PUT', path: '${API_USERS_PATH}/{id}/')
  Future<IdResponse> update(String id, User user) => updateWithCatch(id, user);

  @ApiMethod(method: 'PUT', path: '${API_USERS_PATH}/{id}/password/')
  Future<VoidMessage> changePassword(String id, PasswordChangeRequest pcr) =>catchExceptionsAwait(() async {
    await model.users.changePassword(id, pcr.currentPassword, pcr.newPassword);
    return new VoidMessage();
  });

  @ApiMethod(method: 'DELETE', path: '${API_USERS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) => deleteWithCatch(id);

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_USERS_PATH}/${newId}";
}
