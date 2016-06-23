part of client;

class DartalogHttpClient extends BrowserClient {
  static String _authKey;

  String get _privateAuthKey => _authKey;

  DartalogHttpClient();

  static Future primer() async {
    Option<String> opt = await data_source.settings.getCachedAuthKey();
    _authKey = opt.getOrDefault("");
  }

  static void setAuthKey(String newAuthKey) {
    _authKey = newAuthKey;
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if(!isNullOrWhitespace(_authKey))
      request.headers.putIfAbsent(HttpHeaders.AUTHORIZATION, () => _authKey );

    StreamedResponse response = await super.send(request);

    // Check for changed auth header
    String auth = response.headers[HttpHeaders.AUTHORIZATION];
    if(!isNullOrWhitespace(auth)) {
      if(auth!=_authKey) {
        setAuthKey(auth);
        data_source.settings.cacheAuthKey(auth);
      }
    }


    return response;
  }
}