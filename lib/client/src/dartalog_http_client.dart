import 'dart:async';
import 'dart:html';

import 'package:dartalog/dartalog.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/data_sources/data_sources.dart' as data_source;
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import 'http_headers.dart';

class DartalogHttpClient extends BrowserClient {
  DartalogHttpClient();

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    String authKey =
        (await data_source.settings.getCachedAuthKey()).getOrDefault("");
    if (!isNullOrWhitespace(authKey))
      request.headers.putIfAbsent(HttpHeaders.AUTHORIZATION, () => authKey);

    StreamedResponse response = await super.send(request);

    // Check for changed auth header
    String auth = response.headers[HttpHeaders.AUTHORIZATION];
    if (!isNullOrWhitespace(auth)) {
      if (auth != authKey) {
        await data_source.settings.cacheAuthKey(auth);
      }
    }

    return response;
  }
}
