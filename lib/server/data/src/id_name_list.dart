import 'package:option/option.dart';
import 'a_id_data.dart';
import 'dart:collection';

class IdNameList<T extends AIdData> extends ListBase<T> {
  final List<T> l = <T>[];
  IdNameList();
  IdNameList.copy(Iterable<T> source) {
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

  Option<T> getByID(String id) {
    for (AIdData item in this) {
      if (item.id == id) return new Some<T>(item);
    }
    return new None<T>();
  }

  bool containsId(String id) {
    return getByID(id).any((T item) => true);
  }

  List<String> get idList {
    return this.map((T data) => data.id).toList();
  }

  void sortBytList(List<String> ids) {
    for (int i = 0; i < ids.length; i++) {
      final T item = this
          .getByID(ids[i])
          .getOrElse(() => throw new Exception("${ids[i]} not found in list"));
      this.remove(item);
      this.insert(i, item);
    }
  }
}
