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

  Future reActivate(bool forceRefresh) async {
    await activateInternal(lastArgs, forceRefresh);
  }

  bool userHasPrivilege(String type) {
    if(type==UserPrivilege.none)
      return true;
    return this.currentUser.any((User user) {
      return user.evaluateType(type);
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

  Future activateInternal(Map args, [bool forceRefresh = false]);

  void clearValidation() {
    setGeneralErrorMessage("");
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
        pi.setGeneralErrorMessage("");
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

  Future _handleApiError(commons.DetailedApiRequestError error) async {
    try {
      clearValidation();
      if(error.status==400){
        setGeneralErrorMessage(error.message);
        setFieldErrorMessages(error.errors);
      } else if(error.status==401) {
        await this.mainApp.clearAuthentication();
        await this.mainApp.promptForAuthentication();
        await this.mainApp.evaluateAuthentication();
      } else if(error.status==413) {
        this.showMessage("The submitted data was too large, please submit smaller images");
      } else {
        this.showMessage("API Error: ${error.message} (${error.status})");
      }
    } catch (e, st) {
      loggerImpl.severe(e, st);
      this.handleException(e, st);
    }
  }

  Future handleApiExceptions(toAwait()) async {
    try {
      return await toAwait();
    } on commons.DetailedApiRequestError catch (e, st) {
      await _handleApiError(e);
    } catch (e, st) {
      handleException(e, st);
    }
  }

  void handleException(e, st) {
    loggerImpl.severe(this.tagName, e, st);
    mainApp.handleException(e, st);
  }

  void setFieldErrorMessages(List<commons.ApiRequestErrorDetail> fieldErrors) {
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
        pi.setGeneralErrorMessage(message);
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

  void setGeneralErrorMessage(String message) {
    if (!isNullOrWhitespace(message))
      showMessage(message, "error");
  }
}
