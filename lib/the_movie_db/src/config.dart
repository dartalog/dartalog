part of the_movie_db;

class Config {
  String baseImageUrl, secureBaseImageUrl;

  List<String> posterSizes;

  Map data;
  Config(this.data) {
    this.baseImageUrl = data["images"]["base_url"];
    this.secureBaseImageUrl = data["images"]["secure_base_url"];
    this.posterSizes = data["images"]["poster_sizes"];
  }

  String constructPosterUrl(String poster, [String size = null, bool secure = false]) {
    if(size==null) {
      size = posterSizes[posterSizes.length-1];
    }
    if(secure) {
      return "${secureBaseImageUrl}${size}${poster}";
    } else {
      return "${baseImageUrl}${size}${poster}";
    }
  }
}