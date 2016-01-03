part of api;

class ImportResource {
  static final Logger _log = new Logger('ImportResource');

  @ApiMethod(path: 'import/')
  Future<Map<String,List<String>>> listProviders() async {
    try {
      return { "providers": ["amazon"]};

    } catch(e,st) {
      _log.severe(e,st);
      throw e;
    }
  }

//  @ApiMethod(path: 'import/{provider}')
//  Future<Map<String,List<String>>> listProviderSearchOptions(String provider) async {
//    try {
//      return { "search": ["query", "type"],
//                "import": ["import"]
//              };
//
//    } catch(e,st) {
//      _log.severe(e,st);
//      throw e;
//    }
//  }

  @ApiMethod(path: 'import/{provider}/search/{query}')
  Future<Map<String,Item>> search(String provider, String query, {String template}) async {
    try {
      if(provider!="amazon") {
        throw new Exception("Only provider allowed now is ""amazon""");
      }
      AImportProvider import = new AmazonImportProvider();
      //return await import.search(provider);
    } catch(e,st) {
     _log.severe(e,st);
      throw e;
    }
  }
}