part of import;

class AmazonImportProvider extends AImportProvider {

  static const String BASE_URL = "www.amazon.com/";

  static final List VALID_TYPES = ["music","dvd","videogames","vhs"];

  Future<SearchResults> search(String query, String type_id) async {
    String item_type = "";
    int page = 0;
    String url = "http://${BASE_URL}/exec/obidos/external-search?ie=UTF8&index=${item_type}&keyword=${Uri.encodeComponent(query)}&page=${page}";
    String contents = await this._downloadPage(url);
    List<SearchResult> output = new List<SearchResult>();

    SearchResult result = new SearchResult();
    result.title = "tesT";
    result.id = "1";
    result.thumbnail = "thumb.google.com";
    output.add(result);
    return null;
  }

  Future import(String identifier) async {}
}