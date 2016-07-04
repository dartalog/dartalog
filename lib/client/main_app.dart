// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('main_app.html')
library dartalog.client.main_app;

import 'dart:async';
import 'dart:html';

import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:dartalog/client/api/dartalog.dart' as api;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/controls/paper_toast_queue/paper_toast_queue.dart';
import 'package:dartalog/client/controls/user_auth/user_auth_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/client/pages/checkout/checkout_page.dart';
import 'package:dartalog/client/pages/collections/collections_page.dart';
import 'package:dartalog/client/pages/field_admin/field_admin_page.dart';
import 'package:dartalog/client/pages/item/item_page.dart';
import 'package:dartalog/client/pages/item_add/item_add_page.dart';
import 'package:dartalog/client/pages/item_browse/item_browse_page.dart';
import 'package:dartalog/client/pages/item_edit/item_edit_page.dart';
import 'package:dartalog/client/pages/item_import/item_import_page.dart';
import 'package:dartalog/client/pages/item_type_admin/item_type_admin_page.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/pages/user_admin/user_admin_page.dart';
import 'package:dartalog/dartalog.dart';
import 'package:dartalog/tools.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:logging_handlers/browser_logging_handlers.dart';
import 'package:option/option.dart';
import 'package:path/path.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/paper_badge.dart';
import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_progress.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:route_hierarchical/client.dart';
import 'package:web_components/web_components.dart';


/// Uses [PaperInput]
@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  static final Logger _log = new Logger("MainApp");

  static api.DartalogApi _api;

  @property
  bool appLoadingScreenVisible = true;
  @property
  bool appLoadingSpinnerActive = true;
  @property
  String appLoadingMessage = "Loading application";

  @property
  String visiblePage = "item_browse";
  @property
  int cartCount = 0;

  @property
  bool cartEmpty = true;
  @property
  bool userLoggedIn = false;
  Option<User> currentUser = new None();

  @property
  bool userIsAdmin = false;

  @property
  bool userCanCheckout = false;
  @property
  bool userCanAdd = false;
  @property
  bool userCanBorrow = false;
  @property
  bool loading = true;

  @property
  bool showRefresh = false;

  @property
  bool showSearch = false;
  @property
  bool showAdd = false; // True initially so that it can be found on page load
  @property
  bool showEdit = false;
  @property
  bool showSave = false;
  @property
  bool showDelete = false;
  @property
  bool showBack = false;

  final Router router = new Router(useFragment: true);

  @Property(notify: true)
  APage currentPage = null;

  @property
  String searchText = "";

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());

    // Set up the routes for all the pages.
    router.root
      ..addRoute(
          name: BROWSE_ROUTE_NAME,
          path: "items/:page",
          defaultRoute: true,
          enter: enterRoute)
      ..addRoute(
          name: SEARCH_ROUTE_NAME,
          path: "search/:${ROUTE_ARG_SEARCH_QUERY_NAME}",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: ITEM_VIEW_ROUTE_NAME,
          path: "view/:${ROUTE_ARG_ITEM_ID_NAME}",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: ITEM_EDIT_ROUTE_NAME,
          path: "edit/:${ROUTE_ARG_ITEM_ID_NAME}",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: ITEM_ADD_ROUTE_NAME,
          path: "new/:${ROUTE_ARG_ITEM_TYPE_ID_NAME}",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: ITEM_IMPORT_ROUTE_NAME,
          path: "import",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "field_admin",
          path: "fields",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "collections",
          path: "collections",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "item_type_admin",
          path: "item_types",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "user_admin",
          path: "users",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: CHECKOUT_ROUTE_NAME,
          path: "checkout",
          defaultRoute: false,
          enter: enterRoute)
      ..addRoute(
          name: "logging_output",
          path: "logging_output",
          defaultRoute: false,
          enter: enterRoute);


    startApp();
  }

  CheckoutPage get checkoutPage => $['checkout'];

  @property
  User get currentUserProperty => currentUser.getOrElse(() => new User());

  set currentUserProperty(User user) {
    if (user == null||isNullOrWhitespace(user.name))
      this.currentUser = new None();
    else
      this.currentUser = new Some(user);
  }

  PaperDrawerPanel get drawerPanel => $["drawerPanel"];

  FieldAdminPage get fieldAdmin => $['field_admin'];

  ItemAddPage get itemAddAdmin => $['item_add'];

  ItemTypeAdminPage get itemTypeAdmin => $['item_type_admin'];

  activateRoute(String route, {Map<String, String> arguments}) {
    if (arguments == null) arguments = new Map<String, String>();
    router.go(route, arguments);
  }

  @reflectable
  addClicked(event, [_]) async {
    if (currentPage is ACollectionPage) {
      ACollectionPage page = currentPage as ACollectionPage;
      page.newItem();
    }
  }

  Future addToCart(ItemCopy itemCopy) async {
    await checkoutPage.addToCart(itemCopy);
    refreshCartInfo();
  }



  @reflectable
  backClicked(event, [_]) async {
    currentPage.goBack();
  }

  @reflectable
  void cartClicked(event, [_]) {
    this.activateRoute(CHECKOUT_ROUTE_PATH);
  }

  Future clearAuthentication() async {
    setUserObject(null);
    await data_sources.settings.clearAuthCache();
  }

  @reflectable
  void clearSearch(event, [_]) {
    set("searchText", "");
    if (currentPage is ASearchablePage) {
      ASearchablePage page = currentPage as ASearchablePage;
      page.search("");
    }
  }

  @reflectable
  deleteClicked(event, [_]) async {
    if (currentPage is ADeletablePage) {
      dynamic page = currentPage;
      page.delete();
    }
  }

  @reflectable
  drawerItemClicked(event, [_]) async {
    try {
      Element ele = getParentElement(event.target, "paper-item");
      if (ele != null) {
        String route = ele.dataset["route"];
        switch (route) {
          case "log_in":
            promptForAuthentication();
            break;
          case "log_out":
            await clearAuthentication();
            await evaluateAuthentication();
            break;
          default:
            activateRoute(route);
            break;
        }
      }
    } catch (e, st) {
      _log.severe("drawerItemClicked", e, st);
      handleException(e, st);
    }
  }

  @reflectable
  editClicked(event, [_]) async {
    if (currentPage is AEditablePage) {
      AEditablePage page = currentPage as AEditablePage;
      page.edit();
    }
  }

  Future enterRoute(RouteEvent e) async {
    try {
      startLoading();

      String pageName;
      //set("showBack", (router.activePath.length > 1));

      switch (e.route.name) {
        case SEARCH_ROUTE_NAME:
          pageName = BROWSE_ROUTE_NAME;
          break;
        default:
          pageName = e.route.name;
          break;
      }
      dynamic page = $[pageName];

      if (page == null) {
        throw new Exception("Page not found: ${this.visiblePage}");
      }

      if (!(page is APage)) {
        throw new Exception(
            "Unknown element type: ${page.runtimeType.toString()}");
      }

      await page.activate(_api, e.parameters);

      set("visiblePage", pageName);
      set("currentPage", page);
      evaluatePage();


      evaluatePage();
    } catch (e, st) {
      window.alert(e.toString());
    } finally {
      stopLoading();
    }
  }

//  TemplateAdminPage get templateAdmin=> $['item_type_admin'];
  Future evaluateAuthentication() async {
    bool authed = false;
    try {
      api.User apiUser = await _api.users.getMe();

      setUserObject(new User.copy(apiUser));

      authed = true;
    } on api.DetailedApiRequestError catch (e, st) {
      if (e.status >= 400 && e.status < 500) {
        // Not authenticated, nothing to see here
        await clearAuthentication();
      } else {
        _log.severe("evaluateAuthentication", e, st);
        handleException(e, st);
      }
    }

    set("userCanCheckout", userHasPrivilege(UserPrivilege.checkout));
    set("userIsAdmin", userHasPrivilege(UserPrivilege.admin));
    set("userCanAdd", userHasPrivilege(UserPrivilege.curator));
    set("userCanBorrow", userHasPrivilege(UserPrivilege.patron));

    if (userLoggedIn != authed && this.currentPage != null) {
      this.currentPage.reActivate(true);
    }

    set("userLoggedIn", authed);
  }
//  ItemBrowsePage get itemBrowse=> $['browse'];
//  ItemPage get itemPage=> $['item'];

  void evaluatePage() {
    dynamic page = currentPage;

    if(page!=null) {
      set("currentPage.title", page.title);

      set("showBack", page.showBackButton);
    }


    set("showRefresh", page is ARefreshablePage && page.showRefreshButton);

    set("showAdd", page is ACollectionPage && page.showAddButton);

    set("showSearch", page is ASearchablePage && page.showSearch);

    set("showDelete", page is ADeletablePage && page.showDeleteButton);

    set("showEdit", page is AEditablePage && page.showEditButton);

    set("showSave", page is ASaveablePage && page.showSaveButton);
  }

  void handleException(e, st) {
    if (e is api.DetailedApiRequestError) {
      api.DetailedApiRequestError dare = e as api.DetailedApiRequestError;
      StringBuffer message = new StringBuffer();
      message.writeln(dare.message);
      for (commons.ApiRequestErrorDetail det in e.errors) {
        message.write(det.location);
        message.write(": ");
        message.writeln(det.message);
      }
      showMessage(message.toString(), "error", st.toString());
    }
    if (e is http.ClientException) {
      if (e.message.contains("XMLHttpRequest")) {
        showAppLoadingScreen("Cannot contact server, retrying...");
        new Timer(new Duration(milliseconds: 1000), () async {
          await startApp();
        });
      }
    } else {
      showMessage(e.toString(), "error", st.toString());
    }
  }

  void hideAppLoadingScreen() {
    set("appLoadingScreenVisible", false);
  }

  Future promptForAuthentication() async {
    UserAuthControl ele = $['userAuthElement'];
    await ele.activateDialog();
  }

  void refreshCartInfo() {
    set("cartCount", checkoutPage.cart.length);
    set("cartEmpty", checkoutPage.cart.length == 0);
  }

  @reflectable
  refreshClicked(event, [_]) async {
    startLoading();
    try {
      if (currentPage is ARefreshablePage) {
        dynamic page = currentPage;
        await page.refresh();
      }
    } finally {
      stopLoading();
    }
  }

  void routeChanged() {
    if (visiblePage is! String) return;
    router.go("field_admin", {});
  }

  @reflectable
  saveClicked(event, [_]) async {
    if (currentPage is ASaveablePage) {
      ASaveablePage page = currentPage as ASaveablePage;
      page.save();
    }
  }

  @reflectable
  Future searchKeypress(event, [_]) async {
    if (event.original.charCode == 13) {
      if (currentPage is ASearchablePage) {
        ASearchablePage page = currentPage as ASearchablePage;
        page.search(event.target.value);
      }
    }
  }

  void setSearchText(String value) {
    set("searchText", value);
  }

  setUserObject(User user) {
    if (user == null) {
      set("currentUserProperty.name", "");
      set("currentUserProperty", null);
      AControl.currentUserStatic = this.currentUser;
    } else {
      set("currentUserProperty.name", user.name);
      set("currentUserProperty", user);
      AControl.currentUserStatic = this.currentUser;
    }
  }

  void showAppLoadingScreen([String message = "Loading application"]) {
    set("appLoadingMessage", message);
    set("appLoadingScreenVisible", true);
    set("appLoadingSpinnerActive", true);
  }

  void showMessage(String message, [String severity, String details]) {
    PaperToastQueue toastElement = $['global_toast'];

    if (toastElement == null) window.alert(message);

    toastElement.enqueueMessage(message, severity, details);
  }

  Future stopApp() async {
  }

  bool listenerStarted = false;

  Future startApp() async {
    try {
      _api = new api.DartalogApi(new DartalogHttpClient(),
          rootUrl: getServerRoot(), servicePath: "api/dartalog/0.1/");
      await evaluateAuthentication();
      await checkoutPage.activate(_api, {});
      if (!listenerStarted) {
        router.listen();
        listenerStarted = true;
      }
      hideAppLoadingScreen();
    } catch (e, st) {
      _log.severe("startApp", e, st);
      handleException(e, st);
    }
  }

  void startLoading() {
    set("loading", true);
  }

  void stopAppLoadingSpinner() {
    set("appLoadingSpinnerActive", false);
  }

  void stopLoading() {
    set("loading", false);
  }

  @reflectable
  toggleDrawerClicked(event, [_]) {
    PaperDrawerPanel pdp = $['drawerPanel'];
    pdp.togglePanel();
  }

  bool userHasPrivilege(String needed) {
    return this.currentUser.any((User user) {
      return user.evaluateType(needed);
    });
  }

  // Optional lifecycle methods - uncomment if needed.

//  /// Called when an instance of main-app is inserted into the DOM.
//  attached() {
//    super.attached();
//  }

//  /// Called when an instance of main-app is removed from the DOM.
//  detached() {
//    super.detached();
//  }

//  /// Called when an attribute (such as a class) of an instance of
//  /// main-app is added, changed, or removed.
//  attributeChanged(String name, String oldValue, String newValue) {
//    super.attributeChanged(name, oldValue, newValue);
//  }

//  /// Called when main-app has been fully prepared (Shadow DOM created,
//  /// property observers set up, event listeners attached).
//  ready() {
//  }
}
