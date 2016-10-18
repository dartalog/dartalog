import 'package:dartalog/global.dart';

class PaginatedData<T> {
  int startIndex = 0;
  int get count => data.length;
  int totalCount = 0;
  int limit = DEFAULT_PER_PAGE;

  int get totalPages => (totalCount / limit).ceil();
  int get currentPage => (startIndex / limit).floor();

  List<T> data = [];
}
