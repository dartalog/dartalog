part of the_movie_db;

class SearchResults  {
  int currentPage, totalPages, totalResults;
  Map data;
  Config config;
  List<ASearchResult> results = new List<ASearchResult>();

  SearchResults(this.data, this.config) {
    this.currentPage = data["page"];
    this.totalPages = data["total_pages"];
    this.totalResults = data["total_results"];
    for(Map result in data["results"]) {
      this.results.add(new ASearchResult(result, this.config));
    }
  }
}