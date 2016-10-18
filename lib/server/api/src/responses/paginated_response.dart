import 'package:dartalog/server/data/data.dart';

class PaginatedResponse<T> {
  int startIndex;
  int pageCount;
  int totalCount;

  int page;
  int totalPages;

  List<T> items = new List<T>();

  PaginatedResponse();

  PaginatedResponse.fromPaginatedData(PaginatedData<T> data) {
    _copyPaginatedDataFields(data);

    this.items.addAll(data.data);
  }

  PaginatedResponse.convertPaginatedData(
      PaginatedData data, T conversion(dynamic item)) {
    _copyPaginatedDataFields(data);

    this.items.addAll(data.data.map((dynamic item) => conversion(item)));
  }

  _copyPaginatedDataFields(PaginatedData data) {
    this.startIndex = data.startIndex;
    this.pageCount = data.count;
    this.totalCount = data.totalCount;

    this.page = data.currentPage;
    this.totalPages = data.totalPages;
  }
}
