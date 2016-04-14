part of the_movie_db;

class ASearchResult {
    String id;
    Map data;

    ASearchResult(this.data) {
        this.id = this.data["id"].toString();
    }
}