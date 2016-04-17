part of import;

class AmazonImportProvider extends AScrapingImportProvider {

  static const String BASE_URL = "www.amazon.com";

  static final List VALID_TYPES = ["music","dvd","videogames","vhs"];

  static final RegExp top_reg = new RegExp(r'<li id="result_\d+" data-asin="([^"]+)" class="s-result-item[^"]+">.+?</div></li>', multiLine: true, caseSensitive: false);
  static final RegExp sub_reg = new RegExp(r'<a[^>]+title="([^"]+)"[^>]+href="(http://www.amazon.com/[^/]+/dp/([^/]+)/[^"]+)"[^>]*>', multiLine: true, caseSensitive: false);
  static final RegExp title_reg = new RegExp(r'<h2[^>]+>([^<]+)</h2>', multiLine: true, caseSensitive: false);
  static final RegExp image_reg = new RegExp(r'<img src="([^"+"]+)"[^>]+class="s-access-image[^"]+"[^>]+>', multiLine: true, caseSensitive: false);

  Future<SearchResults> search(String query, String type_id) async {
    String item_type = "";
    int page = 0;
    String url = "http://${BASE_URL}/exec/obidos/external-search?ie=UTF8&index=${item_type}&keyword=${Uri.encodeComponent(query)}&page=${page}";
    String contents = await this._downloadPage(url);
    contents = contents.replaceAll("\r","");
    contents = contents.replaceAll("\n","");
    SearchResults output = new SearchResults();
    output.searchUrl = url;

    Iterable<Match> top_matches = top_reg.allMatches(contents);


    for(Match top_m in top_matches) {
      String sub_content = top_m.group(0);
      Match image_match = image_reg.firstMatch(sub_content);
      Match title_match = title_reg.firstMatch(sub_content);
      Iterable<Match> sub_matches = sub_reg.allMatches(sub_content);
      if(sub_matches.length>0) {
        String image_url = null;
        if(image_match!=null) {
          image_url = image_match.group(1);
        }

        for(Match sub_match in sub_matches) {
          String id = sub_match.group(3);
          SearchResult result = output.getById(id);
          if(result!=null) {
            output.results.remove(result);
          }
          result = new SearchResult();
          result.url = "http://${BASE_URL}/dp/${id}";
          if(sub_matches.length==1) {
            result.title = title_match.group(1);
          } else {
            result.title = "${title_match.group(1)} - ${sub_match.group(1)}";
          }
          result.id = id;
          result.thumbnail = image_url;
          //result.debug = sub_match.group(0);
          output.results.add(result);
        }
      } else {
        //throw new Exception("Too many matches");
      }
    }
    return output;
  }

  Future import(String identifier) async {

  }
}