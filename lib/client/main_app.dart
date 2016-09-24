// Copyright (c) 2016, Matthew Barbour. All rights reserved. Use of this source code
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
import 'package:polymer_elements/app_location.dart';
import 'package:polymer_elements/app_route.dart';
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

import 'package:dartalog/client/pages/pages.dart';

/// Uses [PaperInput]
@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  static final Logger _log = new Logger("MainApp");

  static api.DartalogApi get _api => GLOBAL_API;

  @property
  bool appLoadingScreenVisible = true;
  @property
  bool appLoadingSpinnerActive = true;
  @property
  String appLoadingMessage = "Loading application";

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
  bool showAdd = false; // True initially so that it can be found on page load
  @property
  bool showEdit = false;
  @property
  bool showSave = false;
  @property
  bool showDelete = false;
  @property
  bool showBack = false;

  //final Router router = new Router(useFragment: true);

  @Property(notify: true, observer: "routeChanged")
  Map route;

  @Property(notify: true)
  Map routeData;
  @Property(notify: true)
  Map routeParameters;

  @Property(notify: true)
  Map pageRoute;


  @Property(notify: true)
  bool showPaginator = false;
  @Property(notify: true)
  bool enableNextPage = false;
  @Property(notify: true)
  bool enablePreviousPage = false;

  @property
  List<int> availablePages = new List<int>();

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());

    startApp();
  }
  CheckoutPage get checkoutPage => $['checkout'];

  @property
  APage get currentPage {
    if(routeData!=null) {
      dynamic output = this.querySelector(
          "[data-page='" + routeData["page"] + "']");
      if (output != null)
        return output;
    }
    if (pages == null) return null;
    return pages.selectedItem;
  }

  @property
  User get currentUserProperty => currentUser.getOrElse(() => new User());

  set currentUserProperty(User user) {
    if (user == null || isNullOrWhitespace(user.name))
      this.currentUser = new None();
    else
      this.currentUser = new Some(user);
  }

  PaperDrawerPanel get drawerPanel => $["drawerPanel"];

  FieldAdminPage get fieldAdmin => $['field_admin'];

  ItemAddPage get itemAddAdmin => $['item_add'];

  ItemTypeAdminPage get itemTypeAdmin => $['item_type_admin'];

  IronPages get pages => this.querySelector("iron-pages");

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
    changeRoute("checkout");
  }

  void changeRoute(String page, [Map data]) {
    set("routeData.page", page);
  }

  Future clearAuthentication() async {
    setUserObject(null);
    await data_sources.settings.clearAuthCache();
  }

  @reflectable
  void clearSearch(event, [_]) {
    if (currentPage is ASearchablePage) {
      ASearchablePage page = currentPage as ASearchablePage;
      set("currentPage.searchQuery", "");
      page.search();
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
            break;
        }
      }
    } catch (e, st) {
      _log.severe("drawerItemClicked", e, st);
      handleException(e, st);
    }
  }

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

    if (userLoggedIn != authed && this.currentPage != null && this.currentPage is ARefreshablePage) {
      ARefreshablePage rp = this.currentPage as ARefreshablePage;
      await rp.refresh();
    }

    set("userLoggedIn", authed);
  }

  void evaluateCurrentPage() {
    if(currentPage==null)
      return;

    notifyPath("currentPage", currentPage);

    notifyPath("currentPage.title", currentPage.title);
    document.title = "dartalog -  ${currentPage.title}";

    if (currentPage != null && currentPage is ASearchablePage) {
      ASearchablePage sp = currentPage as ASearchablePage;
      notifyPath("currentPage.showSearch", sp.showSearch);
      notifyPath("currentPage.searchQuery", sp.searchQuery);
    } else {
      notifyPath("currentPage.showSearch", false);
      notifyPath("currentPage.searchQuery", "");
    }

    if (currentPage is ACollectionPage) {
      ACollectionPage cp = currentPage as ACollectionPage;
      _refreshPaginator(cp);
      notifyPath("currentPage.showAddButton", cp.showAddButton);
    } else {
      set("showPaginator", false);
      clear("availablePages");
      set("enableNextPage", false);
      set("enablePreviousPage", false);

      notifyPath("currentPage.showAddButton", false);
      notifyPath("currentPage.currentPage", 0);
      notifyPath("currentPage.totalPages", 0);
    }

    if(currentPage is AEditablePage) {
      AEditablePage ep = currentPage as AEditablePage;
      notifyPath("currentPage.showEditButton", ep.showEditButton);
      notifyPath("currentPage.editLink", ep.editLink);
    } else {
      notifyPath("currentPage.showEditButton", false);
      notifyPath("currentPage.editLink", EMPTY_STRING);
    }

    if(currentPage is ADeletablePage) {
      ADeletablePage dp = currentPage as ADeletablePage;
      notifyPath("currentPage.showDeleteButton", dp.showDeleteButton);
    } else {
      notifyPath("currentPage.showDeleteButton", false);
    }

    if(currentPage is ARefreshablePage) {
      ARefreshablePage rp = currentPage as ARefreshablePage;
      notifyPath("currentPage.showRefreshButton", rp.showRefreshButton);
    } else {
      notifyPath("currentPage.showRefreshButton", false);
    }

  }

  void _refreshPaginator(ACollectionPage cp) {
    notifyPath("currentPage.currentPage", cp.currentPage);
    notifyPath("currentPage.totalPages", cp.totalPages);

    set("showPaginator", cp.totalPages>1);

    if(!showPaginator)
      return;

    clear("availablePages");
    for(int i = 1; i <= cp.totalPages; i++) {
      add("availablePages",i);
    }

    set("enablePreviousPage",cp.currentPage>1);
    set("enableNextPage",cp.currentPage<cp.totalPages);
  }

  void setCurrentPage(int page) {
    set("routeParameters.page", page);
  }

  void nextPage(event,[_]) {
    if(this.currentPage is ACollectionPage) {
      ACollectionPage cp = this.currentPage as ACollectionPage;
      if(cp.totalPages>cp.currentPage)
        this.setCurrentPage(cp.currentPage+1);
    }
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
        page.search();
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

  Future startApp() async {
    try {
      await evaluateAuthentication();

      if (routeData == null || routeData.isEmpty)
        window.location.hash = "items";

      hideAppLoadingScreen();
    } catch (e, st) {
      _log.severe("startApp", e, st);
      handleException(e, st);
    }
  }

  void startLoading() {
    set("loading", true);
  }

  Future stopApp() async {}

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

  void updatePageRoute(Object newPageRoute) {
    set("pageRoute", newPageRoute);
  }

  bool userHasPrivilege(String needed) {
    return this.currentUser.any((User user) {
      return user.evaluateType(needed);
    });
  }

  @reflectable
  routeChanged(oldValue, newValue) {
    notifyPath("browseVisible",browseVisible);
    notifyPath("itemVisible",itemVisible);
    notifyPath("collectionsVisible",collectionsVisible);
    notifyPath("checkoutVisible",checkoutVisible);
    notifyPath("importVisible",importVisible);
    notifyPath("fieldsVisible",fieldsVisible);
    notifyPath("itemTypesVisible",itemTypesVisible);
    notifyPath("usersVisible",usersVisible);
    if(this.currentPage!=null&&this.currentPage is ARefreshablePage) {
      ARefreshablePage rp = this.currentPage as ARefreshablePage;
      rp.refresh();
    }
    evaluateCurrentPage();
  }

  @property
  bool get browseVisible => getMapValue(routeData,"page")=="items";
  @property
  bool get itemVisible => getMapValue(routeData,"page")=="item";
  @property
  bool get collectionsVisible => getMapValue(routeData,"page")=="collections";
  @property
  bool get checkoutVisible => getMapValue(routeData,"page")=="checkout";
  @property
  bool get importVisible => getMapValue(routeData,"page")=="import";
  @property
  bool get fieldsVisible => getMapValue(routeData,"page")=="fields";
  @property
  bool get itemTypesVisible => getMapValue(routeData,"page")=="item_types";
  @property
  bool get usersVisible => getMapValue(routeData,"page")=="users";

  String getMapValue(Map data, String key, [String defaultValue = EMPTY_STRING]) {
    if(data==null||!data.containsKey(key))
      return defaultValue;
    dynamic output =data[key];
    return output;
  }

  @reflectable
  String getPaginationLink(int page) {
    if(this.currentPage==null||!(this.currentPage is ACollectionPage))
      return EMPTY_STRING;

    ACollectionPage cp = this.currentPage as ACollectionPage;
    return "#${cp.getPaginationLink(page)}";
  }

  // Optional lifecycle methods - uncomment if needed.

  /// Called when an instance of main-app is inserted into the DOM.
  attached() {
    super.attached();
    //routeChanged(null);
  }

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
