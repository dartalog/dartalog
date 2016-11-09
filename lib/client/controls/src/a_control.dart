import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:polymer_elements/paper_input_behavior.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/iron_input.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_toggle_button.dart';

import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/main_app.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/api/api.dart' as API;
import 'package:dartalog/client/controls/combo_list/combo_list_control.dart';

export 'package:_discoveryapis_commons/_discoveryapis_commons.dart'
    show ApiRequestErrorDetail;

class AControl extends PolymerElement {
  Logger get loggerImpl;
  MainApp _mainAppCache = null;

  @reflectable
  Future<Null> refresh();

  static Option<User> currentUserStatic = new None();
  Option<User> get currentUser => currentUserStatic;

  MainApp get _mainApp {
    if (_mainAppCache == null) {
      Option<Element> pe = getParentElement(this.parent, "main-app");
      if (pe.isEmpty)
        throw new Exception("Main app element could not be found");
      _mainAppCache = pe.get();
    }
    return _mainAppCache;
  }

  @Property(notify: true, observer: "routeChangedEvent")
  Map route;

  AControl.created() : super.created();

  @reflectable
  void routeChangedEvent(oldRoute, newRoute) {
    this.routeChanged();
  }

  void routeChanged() {}

  void addToCart(ItemCopy itemCopy) {
    this._mainApp.addToCart(itemCopy);
  }

  Future refreshCartInfo() async {
    await this._mainApp.refreshCartInfo();
  }

  Future refreshActivePage() {
    this._mainApp.refreshActivePage();
  }

  void evaluatePage() {
    this._mainApp.evaluateCurrentPage();
  }

  Future evaluateAuthentication() async {
    return await this._mainApp.evaluateAuthentication();
  }

  bool userHasPrivilege(String type) {
    if (type == UserPrivilege.none) return true;
    return this.currentUser.any((User user) {
      return user.evaluateType(type);
    });
  }

  // If you open a dialog too soon after changing its contents, it won't center properly.
  // This delays opening the dialog until the system has had a second to process the DOM change.
  Future openDialog(PaperDialog dialog) async {
    Completer completer = new Completer();
    new Timer(new Duration(milliseconds: 100), () {
      dialog.open();
      completer.complete();
    });
    return completer.future;
  }

  void clearValidation() {
    setGeneralErrorMessage(StringTools.empty);
    for (Element ele in querySelectorAll('${this.tagName} [data-field-id]')) {
      if (ele is IronInput) {
        IronInput pi = ele;
        pi.invalid = false;
      } else if (ele is PaperInput) {
        PaperInput pi = ele;
        pi.invalid = false;
        pi.errorMessage = StringTools.empty;
      } else if (ele is PaperToggleButton) {
        PaperToggleButton ptb = ele;
        ptb.invalid = false;
        //ele.errorMessage = ""; TODO: Error messages for toggle buttons?
      } else if (ele is ComboListControl) {
        ComboListControl pi = ele;
        pi.setGeneralErrorMessage(StringTools.empty);
        pi.setInvalid(false);
      } else if (ele is PaperDropdownMenu) {
        PaperDropdownMenu pi = ele;
        pi.invalid = false;
        pi.errorMessage = StringTools.empty;
      } else {
        window.alert("Unknown control: " + ele.runtimeType.toString());
      }
    }
  }

  Future<Null> _handleApiError(
      API.DetailedApiRequestError error, dynamic st) async {
    try {
      clearValidation();
      if (error.status == 400) {
        if (!handleErrorDetails(error.errors))
          setGeneralErrorMessage(error.message);
      } else if (error.status == 401) {
        await this._mainApp.clearAuthentication();
        await this._mainApp.promptForAuthentication();
        await this._mainApp.evaluateAuthentication();
      } else if (error.status == 413) {
        this.setGeneralErrorMessage(
            "The submitted data was too large, please submit smaller images");
      } else {
        this.setGeneralErrorMessage(
            "API Error: ${error.message} (${error.status})");
      }
    } catch (e, st) {
      loggerImpl.severe(e, st);
      this.handleException(e, st);
    }
  }

  startLoading() {
    this._mainApp.startLoading();
  }

  stopLoading() {
    this._mainApp.stopLoading();
  }

  Future handleApiExceptions(toAwait()) async {
    try {
      return await toAwait();
    } on API.DetailedApiRequestError catch (e, st) {
      await _handleApiError(e, st);
    } catch (e, st) {
      handleException(e, st);
    }
  }

  void handleException(e, st) {
    loggerImpl.severe(this.tagName, e, st);
    _mainApp.handleException(e, st);
  }

  bool handleErrorDetails(List<API.ApiRequestErrorDetail> fieldErrors) {
    bool output = true;
    for (API.ApiRequestErrorDetail detail in fieldErrors) {
      if (detail.message == null || detail.message.length == 0) continue;
      bool result = handleErrorDetail(detail);
      if (!result && output) output = false;
    }
    return output;
  }

  bool handleErrorDetail(API.ApiRequestErrorDetail detail) {
    if (detail.locationType == "field") {
      setFieldMessage(detail.location, detail.message);
      return true;
    } else {
      showMessage(detail.message, "error");
      return false;
    }
  }

  bool setFieldMessage(String field, String message) {
    String selector = '${this.tagName} [data-field-id="${field}"]';
    Element input = querySelector(selector);

    if (input != null) {
      if (input is PaperInputBehavior) {
        PaperInputBehavior pi = input as PaperInputBehavior;
        pi.errorMessage = message;
        pi.invalid = true;
        return true;
      } else if (input is PaperDropdownMenu) {
        PaperDropdownMenu pi = input;
        pi.errorMessage = message;
        pi.invalid = true;
        return true;
      } else if (input is PaperToggleButton) {
        PaperToggleButton ptb = input;
        ptb.invalid = false;
        //ele.errorMessage = ""; TODO: Error messages for toggle buttons?
      } else if (input is ComboListControl) {
        ComboListControl pi = input;
        pi.setGeneralErrorMessage(message);
        pi.setInvalid(true);
        return true;
      } else {
        window.alert("Unknown control: " + input.runtimeType.toString());
      }
    } else {
      showMessage(message, "error");
    }
    return false;
  }

  void showMessage(String message, [String severity]) {
    _mainApp.showMessage(message, severity);
  }

  void setGeneralErrorMessage(String message) {
    if (!StringTools.isNullOrWhitespace(message)) showMessage(message, "error");
  }

  String generateLink(String root, {Map args: null}) {
    String output = "#${root}";
    if (args != null && args.length > 0) {
      List<String> argList = new List<String>();
      for (dynamic key in args.keys) {
        argList.add("${key.toString()}=${args[key].toString()}");
      }
      output = Uri.encodeFull("${output}?${argList.join("&")}");
    }
    return output;
  }

  void navigate(String root) {
    String target = generateLink(root);
    window.location.hash = target;
  }

//  void route(String page, {Map data: null}) {
//    this._mainApp.changeRoute(page,data);
//  }

  Future focusPaperInput(Element input) {
    Completer completer = new Completer();
    new Timer(new Duration(milliseconds: 100), () {
      PaperInput pi = input as PaperInput;
      pi.focus();
      pi.inputElement.focus();
      completer.complete();
    });
    return completer.future;
  }
}
