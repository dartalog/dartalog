part of data;

class BulkImportItem extends JsProxy {
  @Property(notify: true)
  bool selected = true;

  @reflectable
  String query;

  @reflectable
  List<ImportSearchResult> results;

  @Property(notify: true)
  String selectedResult;

  @Property(notify: true)
  String uniqueId;

  Item newItem;

  BulkImportItem(this.query, this.results) {
    if(this.results.isNotEmpty)
      this.selectedResult = this.results.first.id;
  }

}