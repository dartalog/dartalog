part of client;

class DartalogHttpClient extends BrowserClient {
  static String _authKey;

  DartalogHttpClient();

  static Future primer() async {
    Option<String> opt = await getCachedAuthKey();
    _authKey = opt.getOrDefault("");
  }

  static void setAuthKey(String newAuthKey) {
    _authKey = newAuthKey;
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    if(!isNullOrWhitespace(_authKey))
      request.headers.putIfAbsent(HttpHeaders.AUTHORIZATION, () => _authKey );

    return super.send(request);
  }
}