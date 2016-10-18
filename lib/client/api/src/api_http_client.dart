import 'dart:async';

import 'package:dartalog/client/data_sources/data_sources.dart' as data_source;
import 'package:dartalog/tools.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import '../../client.dart';

class ApiHttpClient extends BrowserClient {
  ApiHttpClient();

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final String authKey =
        (await data_source.settings.getCachedAuthKey()).getOrDefault("");
    if (!StringTools.isNullOrWhitespace(authKey))
      request.headers.putIfAbsent(HttpHeaders.AUTHORIZATION, () => authKey);

    final StreamedResponse response = await super.send(request);

    // Check for changed auth header
    final String auth = response.headers[HttpHeaders.AUTHORIZATION];
    if (!StringTools.isNullOrWhitespace(auth)) {
      if (auth != authKey) {
        await data_source.settings.cacheAuthKey(auth);
      }
    }

    return response;
  }
}
