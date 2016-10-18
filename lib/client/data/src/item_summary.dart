import 'package:polymer/polymer.dart';
import 'package:dartalog/client/client.dart';

class ItemSummary extends JsProxy {
  @reflectable
  String id;
  @reflectable
  String name;
  @reflectable
  String thumbnail;
  @reflectable
  String typeId;

  ItemSummary();

  @reflectable
  String get thumbnailUrl => getImageUrl(thumbnail, ImageType.thumbnail);

  ItemSummary.copy(dynamic field) {
    _copy(field, this);
  }

  void copyTo(dynamic output) {
    _copy(this, output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.typeId = from.typeId;
    to.thumbnail = from.thumbnail;
  }

  static List<ItemSummary> convertList(Iterable input) {
    List<ItemSummary> output = new List<ItemSummary>();
    for (dynamic obj in input) {
      output.add(new ItemSummary.copy(obj));
    }
    return output;
  }
}
