import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'src/config.dart';
import 'src/search/search_results.dart';
import 'src/items/movie.dart';

class TheMovieDB {
  String apiKey;

  Config config;

  static final String BASE_URL = "https://api.themoviedb.org/3/";

  TheMovieDB(this.apiKey);

  Future<Map> _fetchJSon(String url) async {
    http.Response response = await http.get(url);
    Map data = JSON.decode(response.body);
    return data;
  }

  Future RefreshConfig() async {
    String request_url = "${BASE_URL}configuration?api_key=${Uri.encodeFull(
        this.apiKey)}";
    Map data = await _fetchJSon(request_url);
    this.config = new Config(data);
  }

  Future<SearchResults> searchMulti(String query,
      [int page = 1,
      String language = null,
      bool include_adult = false]) async {
    if (config == null) {
      await RefreshConfig();
    }
    String request_url = "${BASE_URL}search/multi?query=${Uri.encodeFull(
        query)}&api_key=${Uri.encodeFull(this.apiKey)}";
    Map data = await _fetchJSon(request_url);
    return new SearchResults(data, this.config);
  }

  Future<Movie> getMovie(String id) async {
    if (config == null) {
      await RefreshConfig();
    }
    String request_url = "${BASE_URL}movie/${Uri.encodeFull(id)}?api_key=${Uri
        .encodeFull(this.apiKey)}";
    Map data = await _fetchJSon(request_url);
    return new Movie(data, this.config);
  }

  Future<Movie> getTVSeries(String id) async {
    if (config == null) {
      await RefreshConfig();
    }
    String request_url = "${BASE_URL}movie/${Uri.encodeFull(id)}?api_key=${Uri
        .encodeFull(this.apiKey)}";
    Map data = await _fetchJSon(request_url);
    return new Movie(data, this.config);
  }
}
