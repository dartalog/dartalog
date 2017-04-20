import 'search_result.dart';

class SearchResults {
  int currentPage, totalPages, totalResults;
  String searchUrl;

  Map<String, String> data;
  List<SearchResult> results = new List<SearchResult>();

  SearchResult getById(String id) {
    for (SearchResult sr in results) {
      if (sr.id == id) return sr;
    }
    return null;
  }
}
