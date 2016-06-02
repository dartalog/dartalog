// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('main_app.html')
library dartalog.client.main_app;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/tools.dart';
import 'package:dartalog/client/api/dartalog.dart' as api;
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/paper_toast_queue/paper_toast_queue.dart';
import 'package:dartalog/client/controls/user_auth/user_auth_control.dart';
import 'package:dartalog/client/pages/field_admin/field_admin_page.dart';
import 'package:dartalog/client/pages/item/item_page.dart';
import 'package:dartalog/client/pages/item_add/item_add_page.dart';
import 'package:dartalog/client/pages/item_browse/item_browse_page.dart';
import 'package:dartalog/client/pages/item_edit/item_edit_page.dart';
import 'package:dartalog/client/pages/collections/collections_page.dart';
import 'package:dartalog/client/pages/item_import/item_import_page.dart';
import 'package:dartalog/client/pages/item_type_admin/item_type_admin_page.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:logging/logging.dart';
import 'package:logging_handlers/browser_logging_handlers.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_badge.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/paper_progress.dart';
import 'package:polymer_elements/paper_toolbar.dart';
import 'package:route_hierarchical/client.dart';
import 'package:web_components/web_components.dart';

/// Uses [PaperInput]
@PolymerRegister('main-app')
class MainApp extends PolymerElement {
  static final Logger _log = new Logger("MainApp");

  @property
  String visiblePage = "item_browse";

  @property
  int cartCount = 0;
  @property
  bool cartEmpty = true;

  @Property(notify: true)
  List<ItemCopy> cartContents = new List<ItemCopy>();

  @property
  bool userLoggedIn = false;
  @property User currentUser;

  @property
  bool loading = true;

  @property
  bool showRefresh = false;
  @property
  bool showSearch = false;
  @property
  bool showAdd = false;
  @property
  bool showEdit = false;
  @property
  bool showSave = false;
  @property
  bool showDelete = false;

  @property
  bool showBack = false;

  final Router router = new Router(useFragment: true);

  static final api.DartalogApi _api = new api.DartalogApi(new DartalogHttpClient(),
      rootUrl: SERVER_ADDRESS, servicePath: "api/dartalog/0.1/");

  @Property(notify: true)
  APage currentPage = null;

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created()  {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogPrintHandler());

    // Set up the routes for all the pages.
    DartalogHttpClient.primer();

    router.root
      ..addRoute(
          name: BROWSE_ROUTE_NAME,
          path: "items",
          defaultRoute: true,
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
          name: "logging_output",
          path: "logging_output",
          defaultRoute: false,
          enter: enterRoute);

    router.listen();
    evaluateAuthentication();
  }

  void addToCart(ItemCopy itemCopy) {
    add("cartContents", itemCopy);
    set("cartCount", cartContents.length);
    set("cartEmpty", cartContents.length==0);
  }

  void stopLoading() {
    set("loading", false);
  }

  void startLoading() {
    set("loading", true);
  }

  Future evaluateAuthentication() async {
    bool authed = false;
    try {
      api.User apiUser = await _api.users.getMe();

      set("currentUser", new User.copy(apiUser));
      set("currentUser.name", currentUser.name);
      authed = true;
    } on api.DetailedApiRequestError catch(e,st) {
      if(e.status>=400&&e.status<500) {
        // Not authenticated, nothing to see here
        set("currentUser.name", "");
        set("currentUser", null);
      } else {
        _log.severe("evaluateAuthentication", e, st);
        handleException(e, st);
      }
    } catch(e,st) {
      _log.severe("evaluateAuthentication",e,st);
      handleException(e,st);
    }

    set("userLoggedIn", authed);

  }

  PaperDrawerPanel get drawerPanel => $["drawerPanel"];
  FieldAdminPage get fieldAdmin => $['field_admin'];
//  TemplateAdminPage get templateAdmin=> $['item_type_admin'];
  ItemAddPage get itemAddAdmin => $['item_add'];
//  ItemBrowsePage get itemBrowse=> $['browse'];
//  ItemPage get itemPage=> $['item'];

  ItemTypeAdminPage get itemTypeAdmin => $['item_type_admin'];

  activateRoute(String route, {Map<String, String> arguments}) {
    if (arguments == null) arguments = new Map<String, String>();
    router.go(route, arguments);
  }

  @reflectable toggleDrawerClicked(event, [_]) {
    PaperDrawerPanel pdp = $['drawerPanel'];
    pdp.togglePanel();
  }

  @reflectable
  addClicked(event, [_]) async {
    if (currentPage is ACollectionPage) {
      ACollectionPage page = currentPage as ACollectionPage;
      page.newItem();
    }
  }

  @reflectable
  backClicked(event, [_]) async {
    if (currentPage is ASubPage) {
      ASubPage page = currentPage as ASubPage;
      page.goBack();
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
      if (route == "log_in") {
        UserAuthControl ele = $['userAuthElement'];
        ele.activateDialog();
      } else {
        activateRoute(route);
      }
    }
    } catch (e,st) {
      _log.severe("drawerItemClicked", e,st);
      handleException(e,st);
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
      set("visiblePage", e.route.name);

      set("showBack", (router.activePath.length > 1));

      dynamic page = $[e.route.name];

      if (page == null) {
        throw new Exception("Page not found: ${this.visiblePage}");
      }

      if (!(page is APage)) {
        throw new Exception(
            "Unknown element type: ${page.runtimeType.toString()}");
      }

      set("currentPage", page);
      evaluatePage();
      await this.currentPage.activate(_api, e.parameters);
      stopLoading();
    } catch (e, st) {
      window.alert(e.toString());
    }
  }

  void evaluatePage() {
    set("currentPage.title", currentPage.title);

    set("showBack", currentPage is ASubPage);

    set("showRefresh", currentPage is ARefreshablePage);

    set("showAdd", currentPage is ACollectionPage);

    set("showSearch", currentPage is ASearchablePage);

    set("showDelete", currentPage is ADeletablePage);

    set("showEdit", currentPage is AEditablePage);

    set(
        "showSave",
        currentPage is ASaveablePage &&
            (currentPage as ASaveablePage).showSaveButton);
  }

  void handleException(e, st) {
    showMessage(e.toString(), "error", st.toString());
  }

  @reflectable
  refreshClicked(event, [_]) async {
    if (currentPage is ARefreshablePage) {
      dynamic page = currentPage;
      page.refresh();
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

  void showMessage(String message, [String severity, String details]) {
    PaperToast toastElement = $['global_toast'];

    if (toastElement == null) return;

    if (toastElement.opened) toastElement.opened = false;

    new Timer(new Duration(milliseconds: 300), () {
      if (severity == "error") {
        toastElement.classes.add("error");
      } else {
        toastElement.classes.remove("error");
      }

      if (isNullOrWhitespace(details))
        toastElement.text = "$message";
      else
        toastElement.innerHtml = "<details><summary>${message}</summary><pre>${details}</pre></details>";

      toastElement.show();
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
