part of controls;

class AControl extends PolymerElement {
  Logger get loggerImpl;
  MainApp _mainApp = null;
  API.DartalogApi api;

  static Option<User> currentUserStatic = new None();
  Option<User> get currentUser => currentUserStatic;

  MainApp get mainApp {
    if (_mainApp == null) {
      _mainApp = getParentElement(this.parent, "main-app");
      if (_mainApp == null)
        throw new Exception("Main app element could not be found");
    }
    return _mainApp;
  }

  AControl.created() : super.created();


  Map lastArgs;
  Future activate(API.DartalogApi api, Map args) async {
    this.api = api;
    this.lastArgs = args;
    await activateInternal(args);
  }
  Future reActivate() async {
    await activateInternal(lastArgs);
  }

  bool userHasPrivilege(String privilege) {
    return this.currentUser.any((User user) {
      return user.privileges.contains(privilege)||user.privileges.contains(USER_PRIVILEGE_ADMIN);
    });
  }

  // If you open a dialog too soon after changing its contents, it won't center properly.
  // This delays opening the dialog until the system has had a second to process the DOM change.
  Future openDialog(PaperDialog dialog)  {
    Completer completer = new Completer();
    Timer timer = new Timer(new Duration(milliseconds: 100), () {
      dialog.open();
      completer.complete();
    });
    return completer.future;
  }

  Future activateInternal(Map args);

  void clearValidation() {
    for (Element ele in querySelectorAll('${this.tagName} [data-field-id]')) {
      if (ele is IronInput) {
        IronInput pi = ele as IronInput;
        pi.invalid = false;
      } else if(ele is PaperInput) {
        PaperInput pi = ele as PaperInput;
        ele.invalid = false;
        ele.errorMessage = "";
      } else if(ele is PaperToggleButton) {
        PaperToggleButton pi = ele as PaperToggleButton;
        ele.invalid = false;
        //ele.errorMessage = ""; TODO: Error messages for toggle buttons?
      } else if(ele is ComboListControl) {
        ComboListControl pi = ele as ComboListControl;
        pi.setErrorMessage("");
        pi.setInvalid(false);
      } else if(ele is PaperDropdownMenu) {
        PaperDropdownMenu pi = ele as PaperDropdownMenu;
        ele.invalid = false; //TODO: Once error messages are properly supported, clear them
        //ele.errorMessage = "";
      } else {
        window.alert("Unknown control: " + ele.runtimeType.toString());
      }
    }
  }

  Future _handleApiError(commons.DetailedApiRequestError error,
      {String generalErrorField: ""}) async {
    try {
      clearValidation();
      if(error.status==400){
        if (generalErrorField.length > 0) {
          dynamic input = $[generalErrorField];
          if (input != null) {
            input.text = error.message;
          } else {
            showMessage(error.message, "error");
          }
        } else {
          showMessage(error.message, "error");
        }
        setErrorMessages(error.errors);
      } else if(error.status==401) {
        await this.mainApp.clearAuthentication();
        this.mainApp.promptForAuthentication();
      } else {

      }
    } catch (e, st) {
      loggerImpl.severe(e, st);
      this.handleException(e, st);
    }
  }

  Future handleApiExceptions(toAwait(),
      {String generalErrorField: ""}) async {
    try {
      return await toAwait();
    } on commons.DetailedApiRequestError catch (e, st) {
      await _handleApiError(e, generalErrorField: generalErrorField);
    } catch (e, st) {
      handleException(e, st);
    }
  }

  void handleException(e, st) {
    loggerImpl.severe(this.tagName, e, st);
    mainApp.handleException(e, st);
  }

  void setErrorMessages(List<commons.ApiRequestErrorDetail> fieldErrors) {
    for (commons.ApiRequestErrorDetail detail in fieldErrors) {
      if (detail.message == null || detail.message.length == 0) continue;

      if (detail.locationType == "field") {
        setFieldMessage(detail.location,detail.message);
      } else {
        showMessage(detail.message, "error");
      }
    }
  }

  void setFieldMessage(String field, String message) {
    String selector =
        '${this.tagName} [data-field-id="${field}"]';
    Element input = querySelector(selector);

    if (input != null) {
      if (input is PaperInputBehavior) {
        PaperInputBehavior pi = input as PaperInputBehavior;
        pi.errorMessage = message;
        pi.invalid = true;
      } else if (input is PaperDropdownMenu) {
        PaperDropdownMenu pi = input as PaperDropdownMenu;
        pi.attributes["error"] =
            message; //TODO: Not properly supported yet
        pi.invalid = true;
      } else if(input is PaperToggleButton) {
        PaperToggleButton pi = input as PaperToggleButton;
        input.invalid = false;
        //ele.errorMessage = ""; TODO: Error messages for toggle buttons?
      } else if (input is ComboListControl) {
        ComboListControl pi = input as ComboListControl;
        pi.setErrorMessage(message);
        pi.setInvalid(true);
      } else {
        window.alert("Unknown control: " + input.runtimeType.toString());
      }
    } else {
      showMessage(message, "error");
    }
  }
  void showMessage(String message, [String severity]) {
    mainApp.showMessage(message, severity);
  }
}
