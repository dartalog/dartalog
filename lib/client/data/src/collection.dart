import 'package:polymer/polymer.dart';

class Collection extends JsProxy {
  @reflectable
  String id;
  @reflectable
  String name;

  @reflectable
  bool publiclyBrowsable = false;

  @reflectable
  List<String> curators = <String>[];
  @reflectable
  List<String> browsers = <String>[];

  Collection();

  Collection.copy(dynamic input) {
    _copy(input, this);
  }

  void copyTo(dynamic output) {
    _copy(this, output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.publiclyBrowsable = from.publiclyBrowsable;
    to.curators = from.curators;
    to.browsers = from.browsers;
  }
}
