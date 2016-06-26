part of data;

class IdNameList<T extends AIdData> extends ListBase<T> {
  final List<T> l = [];
  IdNameList();
  IdNameList.copy(Iterable<T> source) {
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

  List get idList {
    return this.map((T data) => data.getId).toList();
  }

  void sortBytList(List<String> ids) {
    for(int i = 0; i < ids.length; i++) {
      T item = this.getByID(ids[i]).getOrElse(()=> throw new Exception("${ids[i]} not found in list"));
      this.remove(item);
      this.insert(i, item);
    }
  }

}