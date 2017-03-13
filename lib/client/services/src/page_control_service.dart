import 'dart:async';

import 'package:angular2/core.dart';
import 'package:dartalog/client/data/data.dart';
import 'page_actions.dart';

@Injectable()
class PageControlService {
  PaginationInfo currentPaginationInfo;

  final StreamController<PaginationInfo> _paginationController =
  new StreamController<PaginationInfo>.broadcast();

  final StreamController<String> _pageTitleController =
  new StreamController<String>.broadcast();

  final StreamController<PageActions> _pageActionController =
  new StreamController<PageActions>.broadcast();

  final StreamController<List<PageActions>> _availablePageActionController =
  new StreamController<List<PageActions>>.broadcast();

  Stream<PageActions> get pageActionRequested => _pageActionController.stream;

  Stream<String> get pageTitleChanged => _pageTitleController.stream;

  Stream<List<PageActions>> get availablePageActionsSet => _availablePageActionController.stream;

  void requestPageAction(PageActions action) {
    switch(action) {
      case PageActions.Search:
        throw new Exception("Use the search() function");
      default:
        this._pageActionController.add(action);
        break;
    }
  }

  Stream<PaginationInfo> get paginationChanged => _paginationController.stream;

  String currentQuery = "";

  final StreamController<String> _searchController =
      new StreamController<String>.broadcast();

  Stream<String> get searchChanged => _searchController.stream;

  void clearPaginationInfo() {
    setPaginationInfo(new PaginationInfo());
  }
  void clearSearch() {
    search("");
  }

  void reset() {
    clearPaginationInfo();
    clearSearch();
    clearPageTitle();
    clearAvailablePageActions();
  }



  void clearAvailablePageActions() {
    setAvailablePageActions(<PageActions>[]);
  }

  void setAvailablePageActions(List<PageActions> actions) {
    _availablePageActionController.add(actions);
  }

  void search(String query) {
    this.currentQuery = query;
    _searchController.add(query);
  }

  void setPaginationInfo(PaginationInfo info) {
    this.currentPaginationInfo = info;
    _paginationController.add(info);
  }

  void setPageTitle(String title) {
    _pageTitleController.add(title);
  }

  void clearPageTitle() {
    setPageTitle("");
  }
}
