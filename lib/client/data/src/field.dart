import 'package:polymer/polymer.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;

class Field extends JsProxy  {
  @reflectable
  String format = "";
  @reflectable
  String id = "";
  @reflectable
  String name = "";
  @reflectable
  String type = "";

  @reflectable
  bool unique = false;

  String _value = "";
  @Property(notify: true)
  String get value => _value;
  set value(String value) {
    _value = value;
    if(type=="image") {
      String url = getImageUrl(value, ImageType.THUMBNAIL);
      this.displayImageUrl = getImageUrl(value, ImageType.THUMBNAIL);
      if(!value.startsWith(HOSTED_IMAGE_PREFIX))
        editImageUrl = value;
    }
  }

  @property
  bool get hasValue => !isNullOrWhitespace(_value);

  @reflectable bool isTypeString = false;
  @reflectable bool isTypeImage = false;

  @reflectable String displayImageUrl = "";
  @reflectable bool imageLoading = false;

  @Property(notify:true) String editImageUrl = "";

  API.MediaMessage mediaMessage;

  Field();

  Field.copy(dynamic field) {
    _copy(field,this);
    switch(this.type) {
      case "string":
      case "hidden":
        isTypeString = true;
        break;
      case "image":
        isTypeImage = true;
        break;
    }
  }

  void copyTo(dynamic output) {
    _copy(this,output);
  }

  void _copy(dynamic from, dynamic to) {
    to.format = from.format;
    to.id = from.id;
    to.name = from.name;
    to.type = from.type;
    to.unique = from.unique;
  }

  static List<Field> convertList(Iterable input) {
    List<Field> output = new List<Field>();
    for(dynamic obj in input) {
      output.add(new Field.copy(obj));
    }
    return output;
  }



}