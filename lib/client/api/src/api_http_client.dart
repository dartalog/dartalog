import 'dart:async';

import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/tools.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import '../../client.dart';

class ApiHttpClient extends BrowserClient {
  final SettingsService _settings;

  ApiHttpClient(this._settings);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final String authKey =
        (await _settings.getCachedAuthKey()).getOrDefault("");
    if (!StringTools.isNullOrWhitespace(authKey))
      request.headers.putIfAbsent(HttpHeaders.AUTHORIZATION, () => authKey);

    request.headers.remove(HttpHeaders.USER_AGENT);
    request.headers.remove(HttpHeaders.CONTENT_LENGTH);

    final StreamedResponse response = await super.send(request);

    // Check for changed auth header
    final String auth = response.headers[HttpHeaders.AUTHORIZATION];
    if (!StringTools.isNullOrWhitespace(auth)) {
      if (auth != authKey) {
        await _settings.cacheAuthKey(auth);
      }
    }

    return response;
  }
}
