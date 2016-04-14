library the_movie_db;

import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'src/search_type.dart';
part 'src/a_search_result.dart';
part 'src/search_results.dart';

class TheMovieDB {
  String apiKey;

  static final String BASE_URL = "https://api.themoviedb.org/3/";

  TheMovieDB(this.apiKey);

  Future<SearchResults> searchMulti(String query,
      [int page = 1, String language = null, bool include_adult = false]) async {

    String request_url = "${BASE_URL}search/multi?query=${Uri.encodeFull(query)}&api_key=${Uri.encodeFull(this.apiKey)}";

      http.Response response = await http.get(request_url);

    Map data = JSON.decode(response.body);
    return new SearchResults(data);

  }
}