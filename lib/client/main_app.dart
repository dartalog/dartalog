// Copyright (c) 2016, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('main_app.html')
library dartalog.client.main_app;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/api/api.dart' as API;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/checkout/checkout_control.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/controls/paper_toast_queue/paper_toast_queue.dart';
import 'package:dartalog/client/controls/user_auth/user_auth_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/client/pages/collections/collections_page.dart';
import 'package:dartalog/client/pages/field_admin/field_admin_page.dart';
import 'package:dartalog/client/pages/item/item_page.dart';
import 'package:dartalog/client/pages/item_add/item_add_page.dart';
import 'package:dartalog/client/pages/item_browse/item_browse_page.dart';
import 'package:dartalog/client/pages/checkin/checkin_page.dart';
import 'package:dartalog/client/pages/item_import/item_import_page.dart';
import 'package:dartalog/client/pages/item_type_admin/item_type_admin_page.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/pages/user_admin/user_admin_page.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:logging_handlers/browser_logging_handlers.dart';
import 'package:option/option.dart';
import 'package:path/path.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/app_location.dart';
import 'package:polymer_elements/app_route.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_flex_layout_classes.dart';
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
  @property
  bool get addItemVisible => getMapValue(routeData, "page") == "add";

  @property
  bool get checkinVisible => getMapValue(routeData, "page") == "checkin";

  @property
  bool get browseVisible => getMapValue(routeData, "page") == "items";

  CheckoutControl get checkoutControl => this.querySelector("#checkoutControl");

  @property
  bool get checkoutVisible => getMapValue(routeData, "page") == "checkout";

  @property
  bool get collectionsVisible =>
      getMapValue(routeData, "page") == "collections";

  @Property(notify: true)
  int get currentPageNumber {
    if (_activePage != null && _activePage is ACollectionPage) {
      ACollectionPage cp = _activePage as ACollectionPage;
      return cp.currentPage;
    }
    return 0;
  }

  @property
  User get currentUserProperty => currentUser.getOrElse(() => new User());

  set currentUserProperty(User user) {
    if (user == null || StringTools.isNullOrWhitespace(user.name))
      this.currentUser = new None();
    else
      this.currentUser = new Some(user);
  }

  PaperDrawerPanel get drawerPanel => $["drawerPanel"];

  @Property(notify: true)
  String get editLink {
    if (_activePage != null && _activePage is AEditablePage) {
      AEditablePage ep = _activePage as AEditablePage;
      return ep.editLink;
    }
    return StringTools.empty;
  }

  FieldAdminPage get fieldAdmin => $['field_admin'];

  @property
  bool get fieldsVisible => getMapValue(routeData, "page") == "fields";

  @property
  bool get importVisible => getMapValue(routeData, "page") == "import";

  ItemAddPage get itemAddAdmin => $['item_add'];

  ItemTypeAdminPage get itemTypeAdmin => $['item_type_admin'];

  @property
  bool get itemTypesVisible => getMapValue(routeData, "page") == "item_types";

  @property
  bool get itemVisible => getMapValue(routeData, "page") == "item";

  @Property(notify: true)
  String get pageTitle {
    if (_activePage != null) return _activePage.pageTitle;
    return StringTools.empty;
  }

  @Property(notify: true)
  String get searchQuery {
    if (_activePage != null && _activePage is ASearchablePage) {
      ASearchablePage sp = _activePage as ASearchablePage;
      return sp.searchQuery;
    }
    return StringTools.empty;
  }

  @Property(notify: true)
  set searchQuery(String query) {
    if (_activePage != null && _activePage is ASearchablePage) {
      ASearchablePage sp = _activePage as ASearchablePage;
      sp.searchQuery = query;
    }
  }

  @Property(notify: true)
  bool get showAddButton {
    if (_activePage != null && _activePage is ACollectionPage) {
      ACollectionPage cp = _activePage as ACollectionPage;
      return cp.showAddButton;
    }
    return false;
  }

  @Property(notify: true)
  bool get showDeleteButton {
    if (_activePage != null && _activePage is ADeletablePage) {
      ADeletablePage dp = _activePage as ADeletablePage;
      return dp.showDeleteButton;
    }
    return false;
  }

  @Property(notify: true)
  bool get showEditButton {
    if (_activePage != null && _activePage is AEditablePage) {
      AEditablePage ep = _activePage as AEditablePage;
      return ep.showEditButton;
    }
    return false;
  }

  @Property(notify: true)
  bool get showRefreshButton {
    if (_activePage != null) {
      return _activePage.showRefreshButton;
    }
    return false;
  }

  @Property(notify: true)
  bool get showSaveButton {
    if (_activePage != null && _activePage is ASaveablePage) {
      ASaveablePage sp = _activePage as ASaveablePage;
      return sp.showSaveButton;
    }
    return false;
  }

  @Property(notify: true)
  bool get showSearch {
    if (_activePage != null && _activePage is ASearchablePage) {
      ASearchablePage sp = _activePage as ASearchablePage;
      return sp.showSearch;
    }
    return false;
  }

  @Property(notify: true)
  int get totalPages {
    if (_activePage != null && _activePage is ACollectionPage) {
      ACollectionPage cp = _activePage as ACollectionPage;
      return cp.totalPages;
    }
    return 0;
  }

  @property
  bool get usersVisible => getMapValue(routeData, "page") == "users";

  APage get _activePage {
    if (routeData != null) {
      dynamic output =
          this.querySelector("[data-page='" + routeData["page"] + "']");
      if (output != null) return output;
    }
    return null;
  }

  @reflectable
  addClicked(event, [_]) async {
    if (_activePage is ACollectionPage) {
      ACollectionPage page = _activePage as ACollectionPage;
      page.newItem();
    }
  }

  Future addToCart(ItemCopy itemCopy) async {
    await checkoutControl.addToCart(itemCopy);
    await refreshCartInfo();
  }

  /// Called when an instance of main-app is inserted into the DOM.
  attached() {
    super.attached();
    //routeChanged(null);
    window.onError.listen((ErrorEvent e) {
      showMessage(e.message);
    });
  }

  @reflectable
  backClicked(event, [_]) async {
    _activePage.goBack();
  }

  @reflectable
  void cartClicked(event, [_]) {
    this.checkoutControl.open();
  }

  void changeRoute(String page, [Map data]) {
    set("routeData.page", page);
  }

  Future clearAuthentication() async {
    setUserObject(null);
    await data_sources.settings.clearAuthCache();
    changeRoute("");
    await wait();
    changeRoute(Pages.items);
  }

  @reflectable
  void clearSearch(event, [_]) {
    if (_activePage is ASearchablePage) {
      ASearchablePage page = _activePage as ASearchablePage;
      set("searchQuery", "");
      page.search();
    }
  }

  @reflectable
  deleteClicked(event, [_]) async {
    if (_activePage is ADeletablePage) {
      dynamic page = _activePage;
      page.delete();
    }
  }

  @reflectable
  drawerItemClicked(event, [_]) async {
    try {
      Option<Element> ele = getParentElement(event.target, "paper-item");
      if (ele.isNotEmpty) {
        String route = ele.get().dataset["route"];
      }
    } catch (e, st) {
      _log.severe("drawerItemClicked", e, st);
      handleException(e, st);
    }
  }

  Future evaluateAuthentication() async {
    bool authed = false;
    try {
      API.User apiUser = await API.item.users.getMe();

      setUserObject(new User.copy(apiUser));

      authed = true;
    } on API.DetailedApiRequestError catch (e, st) {
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

    if (userLoggedIn != authed && this._activePage != null) {
      await _activePage.refresh();
    }

    set("userLoggedIn", authed);
  }

  void evaluateCurrentPage() {
    if (_activePage == null) return;
    notifyPath("pageTitle", pageTitle);
    document.title = "$appTitle -  ${pageTitle}";

    notifyPath("showSearch", showSearch);
    notifyPath("searchQuery", searchQuery);

    notifyPath("showAddButton", showAddButton);

    _refreshPaginator();

    notifyPath("showEditButton", showEditButton);
    notifyPath("editLink", editLink);

    notifyPath("showSaveButton", showSaveButton);
    notifyPath("showDeleteButton", showDeleteButton);

    notifyPath("showRefreshButton", showRefreshButton);
  }

  String getMapValue(Map data, String key,
      [String defaultValue = StringTools.empty]) {
    if (data == null || !data.containsKey(key)) return defaultValue;
    dynamic output = data[key];
    return output;
  }

  @reflectable
  String getPaginationLink(int page) {
    if (this._activePage == null || !(this._activePage is ACollectionPage))
      return StringTools.empty;

    ACollectionPage cp = this._activePage as ACollectionPage;
    return "#${cp.getPaginationLink(page)}";
  }

  void handleException(e, st) {
    if (e is API.DetailedApiRequestError) {
      API.DetailedApiRequestError dare = e as API.DetailedApiRequestError;
      StringBuffer message = new StringBuffer();
      message.writeln(dare.message);
      for (API.ApiRequestErrorDetail det in e.errors) {
        message.write(det.location);
        message.write(": ");
        message.writeln(det.message);
      }
      showMessage(message.toString(), "error", st.toString());
      return;
    }
    if (e is http.ClientException) {
      if (e.message.contains("XMLHttpRequest")) {
        showAppLoadingScreen("Cannot contact server, retrying...");
        new Timer(new Duration(milliseconds: 1000), () async {
          await startApp();
        });
      }
      return;
    }
    showMessage(e.toString(), "error", st.toString());
  }

  void hideAppLoadingScreen() {
    set("appLoadingScreenVisible", false);
  }

  @reflectable
  logInClicked(event, [_]) async {
    promptForAuthentication();
  }

  @reflectable
  logOutClicked(event, [_]) async {
    await clearAuthentication();
    await evaluateAuthentication();
  }

  void nextPage(event, [_]) {
    if (this._activePage is ACollectionPage) {
      ACollectionPage cp = this._activePage as ACollectionPage;
      if (cp.totalPages > cp.currentPage)
        this.setCurrentPage(cp.currentPage + 1);
    }
  }

  Future promptForAuthentication() async {
    UserAuthControl ele = $['userAuthElement'];
    await ele.activateDialog();
  }

  Future refreshActivePage() async {
    if (_activePage != null) {
      await _activePage.refresh();
    }
  }

  Future refreshCartInfo() async {
    int length = (await data_sources.cart.getCart()).length;
    set("cartCount", length);
    set("cartEmpty", length == 0);
  }

  @reflectable
  refreshClicked(event, [_]) async {
    startLoading();
    try {
      await _activePage.refresh();
    } finally {
      stopLoading();
    }
  }

  @reflectable
  routeChanged(oldValue, newValue) {
    notifyPath("browseVisible", browseVisible);
    notifyPath("itemVisible", itemVisible);
    notifyPath("collectionsVisible", collectionsVisible);
    notifyPath("checkoutVisible", checkoutVisible);
    notifyPath("importVisible", importVisible);
    notifyPath("fieldsVisible", fieldsVisible);
    notifyPath("itemTypesVisible", itemTypesVisible);
    notifyPath("usersVisible", usersVisible);
    notifyPath("addItemVisible", addItemVisible);
    if (this._activePage != null) {
      _activePage.refresh();
      evaluateCurrentPage();
    }
  }

  @reflectable
  saveClicked(event, [_]) async {
    if (_activePage is ASaveablePage) {
      ASaveablePage page = _activePage as ASaveablePage;
      page.save();
    }
  }

  @reflectable
  Future searchKeypress(event, [_]) async {
    if (event.original.charCode == 13) {
      if (_activePage is ASearchablePage) {
        ASearchablePage page = _activePage as ASearchablePage;
        page.search();
      }
    }
  }

  void setCurrentPage(int page) {
    set("routeParameters.page", page);
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

  void _refreshPaginator() {
    notifyPath("currentPage", currentPageNumber);
    notifyPath("totalPages", totalPages);

    set("showPaginator", totalPages > 1);

    if (!showPaginator) return;

    clear("availablePages");
    for (int i = 1; i <= totalPages; i++) {
      add("availablePages", i);
    }

    set("enablePreviousPage", currentPageNumber > 1);
    set("enableNextPage", currentPageNumber < totalPages);
  }

  // Optional lifecycle methods - uncomment if needed.

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
