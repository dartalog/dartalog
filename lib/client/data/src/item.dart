import 'package:polymer/polymer.dart';
import 'item_type.dart';
import 'item_copy.dart';
import 'field.dart';
import 'package:dartalog/client/api/api.dart' as API;

class Item {
  @reflectable
  String id;
  @reflectable
  String name;
  @reflectable
  String typeId;
  @reflectable
  ItemType type;

  bool canEdit = false;

  @Property(notify: true)
  List<ItemCopy> copies = new List<ItemCopy>();

  @Property(notify: true)
  List<Field> fields;

  @property
  List<Field> get imageFieldsWithValue {
    List output = this.fields.toList();
    output.retainWhere((Field f) => f.isTypeImage && f.hasValue);
    return output;
  }

  Map<String, String> get values {
    Map<String, String> output = new Map<String, String>();
    for (Field f in fields) {
      output[f.id] = f.value;
    }
    return output;
  }

  void set values(Map<String, String> newValues) {
    for (String key in newValues.keys) {
      Field f = getField(key);
      if (f == null) continue;
      f.value = newValues[key];
    }
  }

  Item();

  Item.forType(ItemType type) {
    this.typeId = type.id;
    this.fields = type.fields;
    this.type = type;
  }

  Item.copy(dynamic input) {
    if (input.type != null) {
      this.type = new ItemType.copy(input.type);
      if (this.type.fields != null) this.fields = this.type.fields;
    }
    if (input.copies != null) {
      for (dynamic copy in input.copies) {
        this.copies.add(new ItemCopy.copyFrom(copy));
      }
    }
    _copy(input, this);
  }

  Field getField(String id) {
    if (this.fields == null) return null;
    for (Field f in this.fields) {
      if (f.id == id) return f;
    }
    return null;
  }

  void applyImportResult(API.ImportResult result) {
    for (Field field in this.fields) {
      field.value = _getImportResultValue(result, field.id);
    }
    this.name = _getImportResultValue(result, "name");
  }

  String _getImportResultValue(API.ImportResult result, String name) {
    if (result == null ||
        !result.values.containsKey(name) ||
        result.values[name].length == 0) return "";
    return result.values[name][0];
  }

  String getFieldValue(String id) {
    return values[id];
  }

  void copyTo(dynamic output) {
    _copy(this, output);
  }

  void _copy(dynamic from, dynamic to) {
    to.id = from.id;
    to.name = from.name;
    to.typeId = from.typeId;
    to.values = from.values;
    to.canEdit = from.canEdit;
  }

  static List<Item> convertList(Iterable input) {
    List<Item> output = new List<Item>();
    for (dynamic obj in input) {
      output.add(new Item.copy(obj));
    }
    return output;
  }
}
