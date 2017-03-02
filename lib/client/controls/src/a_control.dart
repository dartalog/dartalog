import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/api/api.dart' as API;
import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/combo_list/combo_list_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/main_app.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_input.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_input_behavior.dart';
import 'package:polymer_elements/paper_toggle_button.dart';

export 'package:_discoveryapis_commons/_discoveryapis_commons.dart'
    show ApiRequestErrorDetail;

class AControl extends PolymerElement {
  static Option<User> currentUserStatic = new None<User>();
  MainApp _mainAppCache;

  @Property(notify: true, observer: "routeChangedEvent")
  Map route;

  AControl.created() : super.created();
  Option<User> get currentUser => currentUserStatic;

  Logger get loggerImpl;

  MainApp get _mainApp {
    if (_mainAppCache == null) {
      final Option<Element> pe = getParentElement(this.parent, "main-app");
      if (pe.isEmpty)
        throw new Exception("Main app element could not be found");
      _mainAppCache = pe.get();
    }
    return _mainAppCache;
  }

  void addToCart(ItemCopy itemCopy) {
    this._mainApp.addToCart(itemCopy);
  }

  void clearValidation() {
    setGeneralErrorMessage(StringTools.empty);
    for (Element ele in querySelectorAll('${this.tagName} [data-field-id]')) {
      if (ele is IronInput) {
        final IronInput pi = ele;
        pi.invalid = false;
      } else if (ele is PaperInput) {
        final PaperInput pi = ele;
        pi.invalid = false;
        pi.errorMessage = StringTools.empty;
      } else if (ele is PaperToggleButton) {
        final PaperToggleButton ptb = ele;
        ptb.invalid = false;
        //ele.errorMessage = ""; TODO: Error messages for toggle buttons?
      } else if (ele is ComboListControl) {
        final ComboListControl pi = ele;
        pi.setGeneralErrorMessage(StringTools.empty);
        pi.setInvalid(false);
      } else if (ele is PaperDropdownMenu) {
        final PaperDropdownMenu pi = ele;
        pi.invalid = false;
        pi.errorMessage = StringTools.empty;
      } else {
        window.alert("Unknown control: " + ele.runtimeType.toString());
      }
    }
  }

  Future evaluateAuthentication() async {
    return await this._mainApp.evaluateAuthentication();
  }

  void evaluatePage() {
    this._mainApp.evaluateCurrentPage();
  }

  Future focusPaperInput(Element input) {
    final Completer completer = new Completer();
    new Timer(new Duration(milliseconds: 100), () {
      final PaperInput pi = input as PaperInput;
      pi.focus();
      pi.inputElement.focus();
      completer.complete();
    });
    return completer.future;
  }

  String generateLink(String root, {Map args: null}) {
    String output = "#$root";
    if (args != null && args.length > 0) {
      final List<String> argList = new List<String>();
      for (dynamic key in args.keys) {
        argList.add("${key.toString()}=${args[key].toString()}");
      }
      output = Uri.encodeFull("$output?${argList.join("&")}");
    }
    return output;
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

  bool handleErrorDetail(API.ApiRequestErrorDetail detail) {
    if (detail.locationType == "field") {
      setFieldMessage(detail.location, detail.message);
      return true;
    } else {
      showMessage(detail.message, "error");
      return false;
    }
  }

  bool handleErrorDetails(List<API.ApiRequestErrorDetail> fieldErrors) {
    bool output = true;
    for (API.ApiRequestErrorDetail detail in fieldErrors) {
      if (detail.message == null || detail.message.length == 0) continue;
      final bool result = handleErrorDetail(detail);
      if (!result && output) output = false;
    }
    return output;
  }

  // If you open a dialog too soon after changing its contents, it won't center properly.
  // This delays opening the dialog until the system has had a second to process the DOM change.
  void handleException(e, st) {
    loggerImpl.severe(this.tagName, e, st);
    _mainApp.handleException(e, st);
  }

  void navigate(String root) {
    final String target = generateLink(root);
    window.location.hash = target;
  }

  Future openDialog(PaperDialog dialog) async {
    final Completer completer = new Completer();
    new Timer(new Duration(milliseconds: 100), () {
      dialog.open();
      completer.complete();
    });
    return completer.future;
  }

  @reflectable
  Future<Null> refresh();

  Future refreshActivePage() async {
    await this._mainApp.refreshActivePage();
  }

  Future refreshCartInfo() async {
    await this._mainApp.refreshCartInfo();
  }

  void routeChanged() {}

  @reflectable
  void routeChangedEvent(oldRoute, newRoute) {
    this.routeChanged();
  }

  bool setFieldMessage(String field, String message) {
    final String selector = '${this.tagName} [data-field-id="${field}"]';
    final Element input = querySelector(selector);

    if (input != null) {
      if (input is PaperInputBehavior) {
        final PaperInputBehavior pi = input as PaperInputBehavior;
        pi.errorMessage = message;
        pi.invalid = true;
        return true;
      } else if (input is PaperDropdownMenu) {
        final PaperDropdownMenu pi = input;
        pi.errorMessage = message;
        pi.invalid = true;
        return true;
      } else if (input is PaperToggleButton) {
        final PaperToggleButton ptb = input;
        ptb.invalid = false;
        //ele.errorMessage = ""; TODO: Error messages for toggle buttons?
      } else if (input is ComboListControl) {
        final ComboListControl pi = input;
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

  void setGeneralErrorMessage(String message) {
    if (!StringTools.isNullOrWhitespace(message)) showMessage(message, "error");
  }

  void showMessage(String message, [String severity]) {
    _mainApp.showMessage(message, severity);
  }

  void startLoading() {
    this._mainApp.startLoading();
  }

  void stopLoading() {
    this._mainApp.stopLoading();
  }

  bool userHasPrivilege(String type) {
    if (type == UserPrivilege.none) return true;
    return this.currentUser.any((User user) {
      return user.evaluateType(type);
    });
  }

//  void route(String page, {Map data: null}) {
//    this._mainApp.changeRoute(page,data);
//  }

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
}
