part of client;

class DartalogHttpClient extends BrowserClient {
  DartalogHttpClient();

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    String authKey = (await data_source.settings.getCachedAuthKey()).getOrDefault("");
    if(!isNullOrWhitespace(authKey))
      request.headers.putIfAbsent(HttpHeaders.AUTHORIZATION, () => authKey );

    StreamedResponse response = await super.send(request);

    // Check for changed auth header
    String auth = response.headers[HttpHeaders.AUTHORIZATION];
    if(!isNullOrWhitespace(auth)) {
      if(auth!=authKey) {
        await data_source.settings.cacheAuthKey(auth);
      }
    }



    return response;
  }
}