part of data;

class IdNameList<T extends AIdData> extends ListBase<T> {
  final List<T> l = [];
  IdNameList();
  IdNameList.convert(Iterable<T> source) {
    this.addAll(source);
  }

  void set length(int newLength) { l.length = newLength; }
  int get length => l.length;
  T operator [](int index) => l[index];
  void operator []=(int index, T value) { l[index] = value; }

  Option<T> getByID(String id) {
    for(AIdData item in this) {
      if(item.getId==id)
        return new Some(item);
    }
    return new None();
  }

  bool containsId(String id) {
    return getByID(id).any((item) => true);
  }

}