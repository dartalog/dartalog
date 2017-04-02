import 'package:option/option.dart';
import 'package:dartalog/server/data/src/a_uuid_data.dart';
import 'dart:collection';

class UuidDataList<T extends AUuidData> extends ListBase<T> {
  final List<T> l = <T>[];
  UuidDataList();
  UuidDataList.copy(Iterable<T> source) {
    this.addAll(source);
  }

  @override
  set length(int newLength) {
    l.length = newLength;
  }

  @override
  int get length => l.length;

  @override
  T operator [](int index) => l[index];
  @override
  void operator []=(int index, T value) {
    l[index] = value;
  }

  Option<T> getByUuid(String uuid) {
    for (T item in this) {
      if (item.uuid == uuid) return new Some<T>(item);
    }
    return new None<T>();
  }

  bool containsUuid(String uuid) {
    return getByUuid(uuid).any((T item) => true);
  }

  List<String> get uuidList {
    return this.map((T data) => data.uuid).toList();
  }

  void sortBytList(List<String> uuids) {
    for (int i = 0; i < uuids.length; i++) {
      final T item = this.getByUuid(uuids[i]).getOrElse(
          () => throw new Exception("${uuids[i]} not found in list"));
      this.remove(item);
      this.insert(i, item);
    }
  }
}
