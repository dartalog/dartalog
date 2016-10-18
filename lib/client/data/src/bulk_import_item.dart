import 'package:polymer/polymer.dart';
import 'import_search_result.dart';
import 'item.dart';

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
    if (this.results.isNotEmpty) this.selectedResult = this.results.first.id;
  }
}
