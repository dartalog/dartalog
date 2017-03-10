import 'dart:async';
import 'package:dartalog/client/data/data.dart';
import 'package:angular2/core.dart';

@Injectable()
class PageControlService {

  PaginationInfo currentPaginationInfo;

  final StreamController<PaginationInfo> _paginationController =
  new StreamController<PaginationInfo>.broadcast();
  Stream<PaginationInfo> get paginationChanged => _paginationController.stream;

  void setPaginationInfo(PaginationInfo info) {
    this.currentPaginationInfo = info;
    _paginationController.add(info);
  }

  void clearPaginationInfo() {
    setPaginationInfo(new PaginationInfo());
  }

  String currentQuery= "";

  final StreamController<String> _searchController =
  new StreamController<String>.broadcast();
  Stream<String> get searchChanged => _searchController.stream;

  void search(String query) {
    this.currentQuery = query;
    _searchController.add(query);
  }

  void clearSearch() {
    search("");
  }

  void reset() {
    clearPaginationInfo();
    clearSearch();
  }

}

