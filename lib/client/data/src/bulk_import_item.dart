part of data;

class BulkImportItem extends JsProxy {
  @reflectable
  String query;

  @reflectable
  List<ImportSearchResult> results;

  BulkImportItem(this.query, this.results);

}