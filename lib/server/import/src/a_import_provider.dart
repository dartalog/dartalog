part of import;

abstract class AImportProvider {
  Future<SearchResults> search(String query, String type_id);
  Future import(String identifier);

  Future<String> _downloadPage(String url) async {
    HttpClient http = new HttpClient();
    Uri uri = Uri.parse(url);

    HttpClientRequest request = await http.getUrl(uri);
    HttpClientResponse response = await request.close();

    HttpClientResponseBody body =
      await HttpBodyHandler.processResponse(response);

    return body.body.toString();
 }
}