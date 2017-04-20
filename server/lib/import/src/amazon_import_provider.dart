import 'a_scraping_import_provider.dart';
import 'package:dartalog/import/src/scraping/scraping_import_criteria.dart';
import 'package:logging/logging.dart';
import 'dart:async';
import 'search_result.dart';
import 'import_result.dart';
import 'search_results.dart';
import 'package:html/dom.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:dartalog/data_sources/data_sources.dart';
import 'package:html/parser.dart' show parse;

class AmazonImportProvider extends AScrapingImportProvider {
  static final Logger _log = new Logger('AmazonImportProvider');

  static const String baseUrl = "www.amazon.com";

  static final List<String> validTypes = ["music", "dvd", "videogames", "vhs"];

  AmazonImportProvider(AItemTypeDataSource itemTypeDataSource): super(itemTypeDataSource);

  static final RegExp _itemLinkReg = new RegExp(
      r'https?://www.amazon.com/[^/]+/dp/([^/]+)/.+',
      multiLine: true,
      caseSensitive: false);

  static const String name = "amazon";

  static final List<ScrapingImportCriteria> _itemTypeCriteria = [
    new ScrapingImportCriteria(
        elementSelector: 'h1#title > span.a-color-secondary',
        replaceRegex: {
          r"Hardcover": "book",
          r"Mass Market Paperback": "book",
          r"Paperback": "book",
          r"Comic": "comic"
        }),
    new ScrapingImportCriteria(
        elementSelector: 'div#bylineInfo span + span',
        replaceRegex: {r"Blu\-ray": "bluray", r"DVD": "dvd", r"VHS": "vhs"}),
    new ScrapingImportCriteria(
        elementSelector: '#nav-subnav',
        elementAttribute: "data-category",
        replaceRegex: {r"videogames": "video_game"}),
  ];

  static final List<ScrapingImportCriteria> _fieldCriteria = [
    new ScrapingImportCriteria(
        field: "name",
        elementSelector: 'span#productTitle',
        replaceRegex: {r"\[Blu-ray\]": ""}),
    new ScrapingImportCriteria(
        field: "front_cover",
        elementSelector: 'img#imgBlkFront, div#imgTagWrapperId img',
        elementAttribute: 'data-a-dynamic-image',
        contentsRegex: r'("|&quot;)(https?:\/\/.+?)("|&quot;):',
        contentsRegexGroup: 2,
        replaceRegex: {r"\.[_A-Z0-9,]+\.": "."}),
    new ScrapingImportCriteria(
        field: "front_cover",
        elementSelector: 'div#imgTagWrapperId img',
        elementAttribute: 'data-old-hires'),
    new ScrapingImportCriteria(
        field: "director",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: ScrapingImportCriteria.innerHtml,
        contentsRegex: '<b>Directors:</b>([^<]+)',
        contentsRegexGroup: 1,
        multipleValues: true),
    new ScrapingImportCriteria(
        field: "isbn10",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: ScrapingImportCriteria.innerHtml,
        contentsRegex: '<b>ISBN-10:</b>([^<]+)',
        contentsRegexGroup: 1),
    new ScrapingImportCriteria(
        field: "isbn13",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: ScrapingImportCriteria.innerHtml,
        contentsRegex: '<b>ISBN-13:</b>([^<]+)',
        contentsRegexGroup: 1),
    new ScrapingImportCriteria(
        field: "page_count",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: ScrapingImportCriteria.innerHtml,
        contentsRegex: r'<b>[^<]+</b> (\d+) pages',
        contentsRegexGroup: 1),
    new ScrapingImportCriteria(
        field: "binding",
        elementSelector: 'span#productTitle + span',
        elementIndex: 0),
    new ScrapingImportCriteria(
        field: "publisher",
        elementSelector: 'div#detail-bullets ul li',
        elementAttribute: ScrapingImportCriteria.innerHtml,
        contentsRegex: r'<b>Publisher:</b>([^\(]+).+',
        contentsRegexGroup: 1),
    new ScrapingImportCriteria(
        elementSelector: 'div#detail-bullets ul li',
        field: "release_date",
        elementAttribute: ScrapingImportCriteria.innerHtml,
        contentsRegex: r'<b>Publisher:</b>[^\(]+\(([^\)]+)',
        contentsRegexGroup: 1),
    new ScrapingImportCriteria(
        elementSelector: 'div#detail-bullets ul li',
        field: "series",
        elementAttribute: ScrapingImportCriteria.innerHtml,
        contentsRegex: r'<b>Series:</b>([^<]+)',
        contentsRegexGroup: 1),
    new ScrapingImportCriteria(
        elementSelector: 'div#detail-bullets ul li',
        field: "language",
        elementAttribute: ScrapingImportCriteria.innerHtml,
        contentsRegex: r'<b>Language:</b>([^<]+)',
        contentsRegexGroup: 1)
  ];

  @override
  List<ScrapingImportCriteria> get fieldCriteria => _fieldCriteria;

  @override
  String get importProviderName => name;

  @override
  List<ScrapingImportCriteria> get itemTypeCriteria => _itemTypeCriteria;

  @override
  String getItemURL(String id) {
    return "http://${baseUrl}/dp/${id}";
  }

  @override
  Future<ImportResult> import(String id) async {
    ImportResult result = await super.import(id);

    result.values["asin"] = [id];

    return result;
  }

  @override
  Future<SearchResults> search(String query, {int page: 0}) async {
    final String item_type = "";
    final String url =
        "http://$baseUrl/exec/obidos/external-search?ie=UTF8&index=${item_type}&keyword=${Uri.encodeComponent(query)}&page=${page}";
    final String contents = await this.downloadPage(url, stripNewlines: true);

    final Document doc = parse(contents);

    final SearchResults output = new SearchResults();
    output.searchUrl = url;

    if (doc.querySelectorAll("#captchacharacters").isNotEmpty)
      throw new Exception(
          "Amazon is refusing our request due to bot detection, please try again later");

    final List<Element> top_elements = doc.querySelectorAll(".s-result-item");

    for (Element top_element in top_elements) {
      final Element image_element =
          top_element.querySelector("img.s-access-image");
      final Element title_element = top_element.querySelector("h2");
      if (title_element == null) continue;
      final Element title_parent_element = title_element.parent;
      if (title_parent_element == null) continue;

      final String title = title_element.text;
      final String top_url = title_parent_element.attributes["href"];
      if (StringTools.isNullOrWhitespace(top_url) ||
          !_itemLinkReg.hasMatch(top_url)) {
        continue;
      }
      final String top_id = _itemLinkReg.firstMatch(top_url).group(1);

      String imageUrl;

      if (image_element != null) {
        imageUrl = image_element.attributes["src"];
      }

      final SearchResult top_result = new SearchResult();
      top_result.id = top_id;
      top_result.thumbnail = imageUrl;
      top_result.title = title;
      top_result.url = top_url;

      final List<Element> sub_elements = top_element.querySelectorAll("h3");

      if (sub_elements.length > 0) {
        for (Element sub_element in sub_elements) {
          final Element a_element = sub_element.parent;
          if (a_element == null) {
            continue;
          }
          String sub_url = a_element.attributes["href"];
          if (StringTools.isNullOrWhitespace(sub_url) ||
              !_itemLinkReg.hasMatch(sub_url)) {
            continue;
          }

          String sub_id = _itemLinkReg.firstMatch(sub_url).group(1);

          SearchResult result = output.getById(sub_id);
          if (result != null) {
            output.results.remove(result);
          }
          result = new SearchResult();
          result.url = this.getItemURL(sub_id);

          result.title = "${title} - ${sub_element.text}";

          result.id = sub_id;
          result.thumbnail = imageUrl;
          output.results.add(result);
        }
      } else if (sub_elements.length == 0) {
        output.results.add(top_result);
      } else {
        //throw new Exception("Too many matches");
      }
    }
    return output;
  }
}
