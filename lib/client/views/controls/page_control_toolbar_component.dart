import 'dart:html';
import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:angular2/router.dart';
import 'package:dartalog/global.dart';
@Component(
    selector: 'page-control-toolbar',
    styles: const [],
    directives: const [ROUTER_DIRECTIVES,materialDirectives],
    template: '''
      <material-input [(ngModel)]="query" style="color:white;" label="Search" trailingGlyph="search" (keyup)="searchKeyup(\$event)" ></material-input>
      <material-button icon (trigger)="refreshClicked()"><glyph icon="refresh"></glyph></material-button>
    ''')
class PageControlToolbarComponent implements OnDestroy {
  static final Logger _log = new Logger("PageControlToolbarComponent");

  String get pageTitle {
    return appName;
  }

  String query = "";

  void refreshClicked() {
    _pageControl.requestPageAction(PageActions.Refresh);
  }

  final PageControlService _pageControl;

  StreamSubscription<String> _searchSubscription;

  PageControlToolbarComponent(this._pageControl) {
    _searchSubscription = _pageControl.searchChanged.listen(onSearchChanged);
  }

  void searchKeyup(KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER) {
      _pageControl.search(query);
    }
  }

  void onSearchChanged(String query) {
    this.query = query;
  }

  @override
  void ngOnDestroy() {
    _searchSubscription.cancel();
  }

}
