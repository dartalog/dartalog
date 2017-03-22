import 'dart:async';
import 'dart:html';

import 'package:angular2/core.dart';
import 'package:dartalog/client/api/api.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';

import 'api_service.dart';
import 'settings_service.dart';

@Injectable()
class AuthenticationService {
  static final Logger _log = new Logger("AuthenticationService");

  final SettingsService _settings;
  final ApiService _api;
  Option<User> user = new None<User>();

  final StreamController<bool> _authStatusController =
      new StreamController<bool>.broadcast();

  final StreamController<Null> _promptController =
      new StreamController<Null>.broadcast();

  AuthenticationService(this._settings, this._api);

  Stream<bool> get authStatusChanged => _authStatusController.stream;
  bool get canCheckout => hasPrivilege(UserPrivilege.checkout);

  bool get isAdmin => hasPrivilege(UserPrivilege.admin);
  bool get isAuthenticated => user.isNotEmpty;
  bool get isCurator => hasPrivilege(UserPrivilege.curator);

  bool get isPatron => hasPrivilege(UserPrivilege.patron);
  Stream<Null> get loginPrompted => _promptController.stream;

  Future<Null> authenticate(String user, String password) async {
    final String url = "${getServerRoot()}login/";
    final Map<String, String> values = {"username": user, "password": password};

    final HttpRequest request = await HttpRequest.postFormData(url, values);
    if (!request.responseHeaders.containsKey(HttpHeaders.AUTHORIZATION))
      throw new Exception("Response did not include Authorization header");

    final String auth = request.responseHeaders[HttpHeaders.AUTHORIZATION];
    if (StringTools.isNullOrWhitespace(auth))
      throw new Exception("Auth request did not return a key");

    await _settings.cacheAuthKey(auth);

    await evaluateAuthentication();
  }

  Future<Null> clear() async {
    if (this.user.isNotEmpty) {
      this.user = new None<User>();
      _authStatusController.add(false);
    }
    await _settings.clearAuthCache();
  }

  Future<Null> evaluateAuthentication() async {
    try {
      final User apiUser = await _api.users.getMe();
      this.user = new Some<User>(apiUser);
      _authStatusController.add(true);
    } on DetailedApiRequestError catch (e, st) {
      if (e.status >= 400 && e.status < 500) {
        // Not authenticated, nothing to see here
        await clear();
      } else {
        _log.severe("evaluateAuthentication", e, st);
        rethrow;
      }
    }
  }

  bool hasPrivilege(String needed) {
    return this.user.any((User user) {
      return UserPrivilege.evaluate(needed, user.type);
    });
  }

  Future<Null> promptForAuthentication() async {
    _promptController.add(null);
  }
}
