part of the_movie_db;

class ASearchResult {
    String id;
    Map data;
    Config config;

    ASearchResult(this.data, this.config) {
        this.id = this.data["id"].toString();
    }

   String getPosterUrl([String size = null, bool secure = false]) {
    return this.config.constructPosterUrl(this.data["poster_path"],size, secure);
   }
}