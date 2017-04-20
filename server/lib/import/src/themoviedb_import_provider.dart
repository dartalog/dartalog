import 'a_api_import_provider.dart';
import 'dart:async';
import 'search_results.dart';

class TheMovieDbImportProvider extends AAPIImportProvider {
  static final List VALID_TYPES = ["movie", "tv"];

  @override
  Future<SearchResults> search(String query, {int page: 0}) async {
//    themoviedb.TheMovieDB mdb = new themoviedb.TheMovieDB(
//        model.options.getString("themoviedb_api_key"));
//    themoviedb.SearchResults mdbsr = await mdb.searchMulti(query);
//
//    SearchResults results = new SearchResults();
//    results.totalPages = mdbsr.totalPages;
//    results.totalResults = mdbsr.totalResults;
//    results.currentPage = mdbsr.currentPage;
//
//    for (themoviedb.ASearchResult mdbr in mdbsr.results) {
//      SearchResult result = new SearchResult();
//      if (mdbr.data.containsKey("title")) {
//        result.title = mdbr.data["title"];
//      } else if (mdbr.data.containsKey("name")) {
//        result.title = mdbr.data["name"];
//      } else {
//        throw new Exception("No name or title found in search result");
//      }
//      result.id = mdbr.id;
//
//      result.thumbnail = mdbr.getPosterUrl(mdbr.config.posterSizes[0]);
//      results.results.add(result);
//    }
//    return results;
    return new SearchResults();
  }

  @override
  Future import(String identifier) async {}
}
