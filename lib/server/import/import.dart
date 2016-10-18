import 'src/amazon_import_provider.dart';
import 'src/a_import_provider.dart';
import 'src/themoviedb_import_provider.dart';

export 'src/a_import_provider.dart';
export 'src/search_results.dart';
export 'src/import_result.dart';

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
