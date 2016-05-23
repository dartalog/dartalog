part of import;

class AmazonImportProvider extends AScrapingImportProvider {
  static final Logger _log = new Logger('AmazonImportProvider');

  static const String BASE_URL = "www.amazon.com";

  static final List VALID_TYPES = ["music","dvd","videogames","vhs"];

  static final RegExp _item_link_reg = new RegExp(r'http://www.amazon.com/[^/]+/dp/([^/]+)/.+', multiLine: true, caseSensitive: false);

  static final String NAME = "amazon";

  String _getItemURL(String id) {
    return "http://${BASE_URL}/dp/${id}";
  }

  Future<SearchResults> search(String query, String type_id, {int page: 0}) async {
    String item_type = "";
    String url = "http://${BASE_URL}/exec/obidos/external-search?ie=UTF8&index=${item_type}&keyword=${Uri.encodeComponent(query)}&page=${page}";
    String contents = await this._downloadPage(url, stripNewlines: true);

    Document doc = parse(contents);

    SearchResults output = new SearchResults();
    output.searchUrl = url;

    List<Element> top_elements = doc.querySelectorAll(".s-result-item");

    for(Element top_element in top_elements) {

      String sub_content = top_element.toString();

      Element image_element = top_element.querySelector("img.s-access-image");
      Element title_element = top_element.querySelector("h2");
      Element title_parent_element = title_element.parent;
      if(title_element==null||title_parent_element==null)
        continue;

      String title = title_element.text;
      String top_url = title_parent_element.attributes["href"];
      if(isNullOrWhitespace(top_url)||!_item_link_reg.hasMatch(top_url)) {
        continue;
      }
      String top_id  = _item_link_reg.firstMatch(top_url).group(1);

      String image_url = null;

      if(image_element!=null) {
        image_url =  image_element.attributes["src"];
      }

      SearchResult top_result = new SearchResult();
      top_result.id = top_id;
      top_result.thumbnail = image_url;
      top_result.title = title;
      top_result.url = top_url;


      List<Element> sub_elements = top_element.querySelectorAll("h3");

      if(sub_elements.length>0) {
        for(Element sub_element in sub_elements) {
          Element a_element = sub_element.parent;
          if(a_element==null) {
            continue;
          }
          String sub_url = a_element.attributes["href"];
          if(isNullOrWhitespace(sub_url)||!_item_link_reg.hasMatch(sub_url)) {
            continue;
          }

          String sub_id = _item_link_reg.firstMatch(sub_url).group(1);

          SearchResult result = output.getById(sub_id);
          if(result!=null) {
            output.results.remove(result);
          }
          result = new SearchResult();
          result.url = this._getItemURL(sub_id);

          result.title = "${title} - ${sub_element.text}";

          result.id = sub_id;
          result.thumbnail = image_url;
          output.results.add(result);
        }
      } else {
        //throw new Exception("Too many matches");
      }
    }
    return output;
  }

  static List<ImportFieldCriteria> fieldCriteria = [
    new ImportFieldCriteria(
        field: "name",
        elementSelector: 'span#productTitle'
    ),
    new ImportFieldCriteria(
        field: "front_cover",
        elementSelector: 'img#imgBlkFront',
        elementAttribute: 'data-a-dynamic-image',
        contentsRegex: r'"(http://.+?)":',
        contentsRegexGroup: 1,
        replaceRegex: {r"\.[_A-Z0-9,]+\.": "."}
    //{"http://ecx.images-amazon.com/images/I/61ghr6rr4%2BL._SX421_BO1,204,203,200_.jpg":[423,500],"http://ecx.images-amazon.com/images/I/61ghr6rr4%2BL._SX258_BO1,204,203,200_.jpg":[260,307]}
    ),
    new ImportFieldCriteria(
        field: "director",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: 'innerHtml',
        contentsRegex: '<b>Directors:</b>(.+)',
        contentsRegexGroup: 1,
        multipleValues: true
    ),
    new ImportFieldCriteria(
        field: "isbn10",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: 'innerHtml',
        contentsRegex: '<b>ISBN-10:</b>(.+)',
        contentsRegexGroup: 1
    ),
    new ImportFieldCriteria(
        field: "isbn13",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: 'innerHtml',
        contentsRegex: '<b>ISBN-13:</b>(.+)',
        contentsRegexGroup: 1
    ),
    new ImportFieldCriteria(
        field: "page_count",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: 'innerHtml',
        contentsRegex: r'<b>[^<]+</b> (\d+) pages',
        contentsRegexGroup: 1
    ),
    new ImportFieldCriteria(
        field: "binding",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: 'innerHtml',
        contentsRegex: r'<b>([^<]+):</b> \d+ pages',
        contentsRegexGroup: 1
    ),
    new ImportFieldCriteria(
        field: "publisher",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: 'innerHtml',
        contentsRegex: r'<b>Publisher:</b>([^\(]+).+',
        contentsRegexGroup: 1
    ),
    new ImportFieldCriteria(
        elementSelector: 'div#detail-bullets ul li',
        field: "release_date",
        elementAttribute: 'innerHtml',
        contentsRegex: r'<b>Publisher:</b>[^\(]+\(([^\)]+)',
        contentsRegexGroup: 1
    ),
    new ImportFieldCriteria(
        elementSelector: 'div#detail-bullets ul li',
        field: "series",
        elementAttribute: 'innerHtml',
        contentsRegex: r'<b>Series:</b>(.+)',
        contentsRegexGroup: 1
    ),
    new ImportFieldCriteria(
        elementSelector: 'div#detail-bullets ul li',
        field: "language",
        elementAttribute: 'innerHtml',
        contentsRegex: r'<b>Language:</b>(.+)',
        contentsRegexGroup: 1
    )
  ];

  List<ImportFieldCriteria> _getFieldCriteria() => fieldCriteria;
  String _getImportProviderName() => NAME;

  Future<ImportResult> import(String id) async {
    ImportResult result = await super.import(id);

    result.values["asin"] = [id];

    return result;
  }
}