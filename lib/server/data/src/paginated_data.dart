part of data;

class PaginatedData<T> {
  int startIndex;
  int get count => data.length;
  int totalCount;
  int limit;

  int get totalPages => (totalCount/limit).ceil();
  int get currentPage => (startIndex/limit).floor();

  List<T> data = [];
}