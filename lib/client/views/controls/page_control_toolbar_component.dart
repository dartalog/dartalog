import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/global.dart';
import 'package:logging/logging.dart';

@Component(
    selector: 'page-control-toolbar',
    styles: const [],
    directives: const [ROUTER_DIRECTIVES, materialDirectives],
    template: '''
      <material-input *ngIf="showSearch" [(ngModel)]="query" style="color:white;" label="Search" trailingGlyph="search" (keyup)="searchKeyup(\$event)" ></material-input>
      <material-button *ngIf="showAddButton" icon (trigger)="addClicked()"><glyph icon="add"></glyph></material-button>
      <material-button *ngIf="showRefreshButton" icon (trigger)="refreshClicked()"><glyph icon="refresh"></glyph></material-button>
    ''')
class PageControlToolbarComponent implements OnDestroy {
  static final Logger _log = new Logger("PageControlToolbarComponent");

  String query = "";

  final PageControlService _pageControl;

  bool showRefreshButton = false;

  bool showAddButton = false;

  bool showSearch = false;
  StreamSubscription<String> _searchSubscription;
  StreamSubscription<List> _pageActionsSubscription;

  PageControlToolbarComponent(this._pageControl) {
    _searchSubscription = _pageControl.searchChanged.listen(onSearchChanged);
    _pageActionsSubscription =
        _pageControl.availablePageActionsSet.listen(onPageActionsSet);
  }
  String get pageTitle {
    return appName;
  }

  @override
  void ngOnDestroy() {
    _searchSubscription.cancel();
    _pageActionsSubscription.cancel();
  }

  void onPageActionsSet(List<PageActions> actions) {
    showRefreshButton = actions.contains(PageActions.Refresh);
    showAddButton = actions.contains(PageActions.Add);
    showSearch = actions.contains(PageActions.Search);
  }

  void onSearchChanged(String query) {
    this.query = query;
  }

  void refreshClicked() {
    _pageControl.requestPageAction(PageActions.Refresh);
  }

  void addClicked() {
    _pageControl.requestPageAction(PageActions.Add);
  }

  void searchKeyup(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER) {
      _pageControl.search(query);
    }
  }
}
