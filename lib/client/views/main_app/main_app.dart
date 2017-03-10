import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/client/views/controls/auth_status_component.dart';
import 'package:dartalog/client/views/controls/login_form_component.dart';
import 'package:dartalog/client/views/item_browse/item_browse.dart';
import 'package:dartalog/client/views/controls/paginator_component.dart';
import 'package:dartalog/client/views/controls/page_control_toolbar_component.dart';
import 'package:dartalog/data/data.dart';
import 'package:polymer_elements/iron_flex_layout/classes/iron_flex_layout.dart';
import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_material.dart';
import 'package:polymer_elements/iron_image.dart';


@Component(
    selector: 'main-app',
    encapsulation: ViewEncapsulation.Native,
    templateUrl: 'main_app.html',
    directives: const [
      ROUTER_DIRECTIVES,
      materialDirectives,
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
@RouteConfig( const [
  const Route(
      path: '/',
      name: 'Home',
      component: ItemBrowseComponent,
      useAsDefault: true),
  const Route(
      path: '/items/:page',
      name: 'ItemsPage',
      component: ItemBrowseComponent),
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
      component: ItemBrowseComponent,),
])
class MainApp implements OnInit  {
  String appName = "Dartalog";

  final AuthenticationService _auth;
  final Location _location;
  final Router _router;

  bool isLoginOpen = false;

  MainApp(this._auth, this._location, this._router);

  User get currentUser => _auth.user.first;

  String get pageTitle {
    return appName;
  }

  bool get userLoggedIn {
    return _auth.isAuthenticated;
  }

  Future<Null> clearAuthentication() async {
    await _auth.clear();
    await _router.navigate(["Home"]);
  }

  @override
  void ngOnInit() {
    _auth.evaluateAuthentication();
  }

  void promptForAuthentication() {
    isLoginOpen = true;
  }
}
