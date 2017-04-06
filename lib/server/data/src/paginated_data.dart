import 'package:dartalog/global.dart';

class PaginatedData<T> {
  int startIndex = 0;
  int get count => data.length;
  int totalCount = 0;
  int limit = defaultPerPage;

  int get totalPages => (totalCount / limit).ceil();
  int get currentPage => (startIndex / limit).floor();

  final List<T> _data = <T>[];
  List<T> get data => _data;
}
