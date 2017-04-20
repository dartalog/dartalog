import 'src/amazon_import_provider.dart';
import 'src/a_import_provider.dart';
import 'src/themoviedb_import_provider.dart';
import 'package:dartalog/data_sources/data_sources.dart';

export 'src/a_import_provider.dart';
export 'src/search_results.dart';
export 'src/import_result.dart';

class ImportProvider {
  static const String amazon = AmazonImportProvider.name;
  static const String movieDb = "themoviedb";

  static AImportProvider getProvider(String provider, AItemTypeDataSource itemTypeDataSource) {
    switch (provider) {
      case ImportProvider.amazon:
        return new AmazonImportProvider(itemTypeDataSource);
      case ImportProvider.movieDb:
        return new TheMovieDbImportProvider();
      default:
        throw new Exception("Unknown import provider");
    }
  }
}
