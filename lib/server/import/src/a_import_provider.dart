import 'dart:async';
import 'search_results.dart';
import 'import_result.dart';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:http_server/http_server.dart';

abstract class AImportProvider {
  Future<SearchResults> search(String query, {int page: 0});
  Future<ImportResult> import(String id);

  @protected
  Future<String> downloadPage(String url, {bool stripNewlines: false}) async {
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

  @protected
  void attemptAutoMapping(dynamic output, Map data) {

  }
}