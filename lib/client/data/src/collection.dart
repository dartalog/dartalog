part of data;
class Collection extends JsProxy {
  @reflectable
  String id;
  @reflectable
  String name;

  Collection();

  Collection.copy(dynamic input) {
    _copy(input,this);
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
  }

}