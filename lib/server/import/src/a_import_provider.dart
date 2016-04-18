part of import;

abstract class AImportProvider {
  Future<SearchResults> search(String query, String type_id, {int page: 0});
  Future<ImportResult> import(String id);

  Future<String> _downloadPage(String url, {bool stripNewlines: false}) async {
    HttpClient http = new HttpClient();
    Uri uri = Uri.parse(url);

    HttpClientRequest request = await http.getUrl(uri);
    HttpClientResponse response = await request.close();

    HttpClientResponseBody body =
    await HttpBodyHandler.processResponse(response);

    String output =body.body.toString();
    if(stripNewlines) {
      output = output.replaceAll("\r","");
      output = output.replaceAll("\n","");
    }
    return output;
 }

  void _attemptAutoMapping(dynamic output, Map data) {

  }
}