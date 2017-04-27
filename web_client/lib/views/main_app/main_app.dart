import 'dart:async';
import 'dart:html' as html;

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:dartalog/api/api.dart';
import 'package:dartalog/routes.dart';
import 'package:dartalog/services/services.dart';
import 'package:dartalog/views/controls/auth_status_component.dart';
import 'package:dartalog/views/controls/login_form_component.dart';
import 'package:dartalog/views/controls/paginator_component.dart';
import 'package:dartalog/views/pages/pages.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:logging/logging.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_material.dart';
import 'package:polymer_elements/paper_toolbar.dart';

@Component(
    selector: 'main-app',
    //encapsulation: ViewEncapsulation.Native,
    templateUrl: 'main_app.html',
    styleUrls: const [
      '../shared.css',
      'main_app.css'
    ],
    directives: const [
      ROUTER_DIRECTIVES,
      materialDirectives,
      pageDirectives,
      LoginFormComponent,
      AuthStatusComponent,
      PaginatorComponent,
    ],
    providers: const [
      FORM_PROVIDERS,
      ROUTER_PROVIDERS,
      materialProviders,
      PageControlService,
      SettingsService,
      ApiService,
      AuthenticationService,
      CartService,
      const Provider(APP_BASE_HREF, useValue: "/"),
      const Provider(LocationStrategy, useClass: HashLocationStrategy),
    ])
@RouteConfig(routes)
class MainApp implements OnInit, OnDestroy {
  static final Logger _log = new Logger("MainApp");

  final AuthenticationService _auth;

  final Location _location;
  final Router _router;
  final PageControlService _pageControl;
  bool isLoginOpen = false;

  bool showRefreshButton = false;

  bool showAddButton = false;

  bool showSearch = false;

  bool userIsCurator = false;
  bool userIsAdmin = false;

  StreamSubscription<String> _pageTitleSubscription;
  StreamSubscription<String> _searchSubscription;
  StreamSubscription<List> _pageActionsSubscription;
  StreamSubscription<Null> _loginRequestSubscription;

  String _pageTitleOverride = "";

  String query = "";

  MainApp(this._auth, this._location, this._router, this._pageControl) {
    _pageTitleSubscription =
        _pageControl.pageTitleChanged.listen(onPageTitleChanged);
    _loginRequestSubscription =
        _auth.loginPrompted.listen(promptForAuthentication);
    _searchSubscription = _pageControl.searchChanged.listen(onSearchChanged);
    _pageActionsSubscription =
        _pageControl.availablePageActionsSet.listen(onPageActionsSet);
  }

  User get currentUser => _auth.user.first;

  String get pageTitle {
    if (StringTools.isNotNullOrWhitespace(_pageTitleOverride)) {
      return _pageTitleOverride;
    } else {
      return appName;
    }
  }

  bool get userLoggedIn {
    return _auth.isAuthenticated;
  }

  void addClicked() {
    _pageControl.requestPageAction(PageActions.Add);
  }

  Future<Null> clearAuthentication() async {
    await _auth.clear();
    //await _router.navigate(<dynamic>["Home"]);
  }

  @override
  void ngOnDestroy() {
    _pageTitleSubscription.cancel();
    _loginRequestSubscription.cancel();
    _searchSubscription.cancel();
    _pageActionsSubscription.cancel();
  }

  @override
  Future<Null> ngOnInit() async {
    try {
      await _auth.evaluateAuthentication();
    } on DetailedApiRequestError catch (e, st) {
      if (e.status == httpStatusServerNeedsSetup) {
        await _router.navigate([setupRoute.name]);
      } else {
        _log.severe("evaluateAuthentication", e, st);
        rethrow;
      }
    }
  }

  void onPageActionsSet(List<PageActions> actions) {
    showRefreshButton = actions.contains(PageActions.Refresh);
    showAddButton = actions.contains(PageActions.Add);
    showSearch = actions.contains(PageActions.Search);
  }

  void onPageTitleChanged(String title) {
    this._pageTitleOverride = title;
  }

  void onSearchChanged(String query) {
    this.query = query;
  }

  void promptForAuthentication([Null nullValue = null]) {
    isLoginOpen = true;
  }

  void refreshClicked() {
    _pageControl.requestPageAction(PageActions.Refresh);
  }

  void searchKeyup(html.KeyboardEvent e) {
    if (e.keyCode == html.KeyCode.ENTER) {
      _pageControl.search(query);
    }
  }
}
