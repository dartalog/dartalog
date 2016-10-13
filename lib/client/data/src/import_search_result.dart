import 'package:polymer/polymer.dart';

class ImportSearchResult extends JsProxy {
  @reflectable
  String debug;
  @reflectable
  String id;
  @reflectable
  String thumbnail;
  @reflectable
  String title;
  @reflectable
  String url;

  ImportSearchResult.copy(dynamic field) {
    _copy(field,this);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.thumbnail = from.thumbnail;
    to.title = from.title;
    to.url = from.url;
  }

  static List<ImportSearchResult> convertList(Iterable input) {
    List<ImportSearchResult> output = [];
    for (dynamic sr in input) {
      output.add(new ImportSearchResult.copy(sr));
    }
    return output;
  }
}