part of data;

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
}