library import;

import 'dart:async';
import 'dart:io';
import 'dart:convert';


import 'package:http_server/http_server.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';

import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/the_movie_db/the_movie_db.dart' as themoviedb;
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/server/model/model.dart' as model;
import 'package:dartalog/server/server.dart';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'package:dartalog/tools.dart';

part 'src/import_object_type.dart';
part 'src/search_result.dart';
part 'src/search_results.dart';
part 'src/import_result.dart';
part 'src/scraping_import_criteria.dart';
part 'src/a_import_provider.dart';
part 'src/a_scraping_import_provider.dart';
part 'src/a_api_import_provider.dart';
part 'src/amazon_import_provider.dart';
part 'src/themoviedb_import_provider.dart';

class ImportProvider {
  static const AMAZON = AmazonImportProvider.NAME;
  static const MOVIEDB = "themoviedb";

  static AImportProvider getProvider(String provider) {
    switch (provider) {
      case ImportProvider.AMAZON:
        return new AmazonImportProvider();
      case ImportProvider.MOVIEDB:
        return new TheMovieDbImportProvider();
      default:
        throw new Exception("Unknown import provider");
    }
  }

}