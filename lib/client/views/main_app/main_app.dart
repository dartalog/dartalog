import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/views/controls/auth_status_component.dart';
import 'package:dartalog/client/views/controls/login_form_component.dart';
import 'package:dartalog/client/views/controls/page_control_toolbar_component.dart';
import 'package:dartalog/client/views/controls/paginator_component.dart';
import 'package:dartalog/client/views/pages/pages.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
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
      'main_app.css'
    ],
    directives: const [
      ROUTER_DIRECTIVES,
      materialDirectives,
      pageDirectives,
      LoginFormComponent,
      PageControlToolbarComponent,
      AuthStatusComponent,
      PaginatorComponent,
    ],
    providers: const [
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
@RouteConfig(const [
  const Route(
      path: '/',
      name: 'Home',
      component: ItemBrowseComponent,
      useAsDefault: true),
  const Route(
      path: '/items/:page', name: 'ItemsPage', component: ItemBrowseComponent),
  const Route(
      path: '/items/search/:query',
      name: 'ItemsSearch',
      component: ItemBrowseComponent),
  const Route(
      path: '/items/search/:query/:page',
      name: 'ItemsSearchPage',
      component: ItemBrowseComponent),
  const Route(
    path: '/item/:id',
    name: 'Item',
    component: ItemBrowseComponent,
  ),
  const Route(
    path: '/collections',
    name: 'Collections',
    component: CollectionsPage,
  ),
])
class MainApp implements OnInit, OnDestroy {
  final AuthenticationService _auth;

  final Location _location;
  final Router _router;
  final PageControlService _pageControl;
  bool isLoginOpen = false;

  StreamSubscription<String> _pageTitleSubscription;

  StreamSubscription<Null> _loginRequestSubscription;

  String _pageTitleOverride = "";

  MainApp(this._auth, this._location, this._router, this._pageControl) {
    _pageTitleSubscription =
        _pageControl.pageTitleChanged.listen(onPageTitleChanged);
    _loginRequestSubscription = _auth.loginPrompted.listen(promptForAuthentication);
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

  Future<Null> clearAuthentication() async {
    await _auth.clear();
    //await _router.navigate(<dynamic>["Home"]);
  }

  @override
  void ngOnDestroy() {
    _pageTitleSubscription.cancel();
    _loginRequestSubscription.cancel();
  }

  @override
  void ngOnInit() {
    _auth.evaluateAuthentication();
  }

  void onPageTitleChanged(String title) {
    this._pageTitleOverride = title;
  }

  void promptForAuthentication([Null nullValue = null]) {
    isLoginOpen = true;
  }
}
