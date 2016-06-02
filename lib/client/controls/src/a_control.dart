part of controls;

class AControl extends PolymerElement {
  MainApp _mainApp = null;

  DartalogApi api;
  AControl.created() : super.created();

  Logger get loggerImpl;

  MainApp get mainApp {
    if (_mainApp == null) {
      _mainApp = getParentElement(this.parent, "main-app");
      if (_mainApp == null)
        throw new Exception("Main app element could not be found");
    }
    return _mainApp;
  }

  Future activate(DartalogApi api, Map args) async {
    this.api = api;
    await activateInternal(args);
  }

  Future activateInternal(Map args);

  void clearValidation() {
    for (Element ele in querySelectorAll('${this.tagName} [data-id-field]')) {
      if (ele is IronInput) {
        IronInput pi = ele as IronInput;
        pi.invalid = false;
      } else {
        window.alert("Unknown control: " + ele.runtimeType.toString());
      }
    }
  }

  void handleApiError(commons.DetailedApiRequestError error,
      {String generalErrorField: ""}) {
    try {
      clearValidation();
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
      setErrorMesage(error.errors);
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
      handleApiError(e, generalErrorField: generalErrorField);
    } catch (e, st) {
      handleException(e, st);
    }
  }

  void handleException(e, st) {
    loggerImpl.severe(this.tagName, e, st);
    mainApp.handleException(e, st);
  }

  @reflectable
  paperDialogCancelClicked(event, [_]) {
    PaperDialog pd = getParentElement(event.target, "paper-dialog");
    if (pd != null) pd.cancel();
  }

  void setErrorMesage(List<commons.ApiRequestErrorDetail> fieldErrors) {
    for (commons.ApiRequestErrorDetail detail in fieldErrors) {
      if (detail.message == null || detail.message.length == 0) continue;

      if (detail.locationType == "field") {
        String selector =
            '${this.tagName} [data-field-id="${detail.location}"]';
        Element input = querySelector(selector);

        if (input != null) {
          if (input is PaperInputBehavior) {
            PaperInputBehavior pi = input as PaperInputBehavior;
            pi.errorMessage = detail.message;
            pi.invalid = true;
          } else if (input is PaperDropdownMenu) {
            PaperDropdownMenu pi = input as PaperDropdownMenu;
            pi.attributes["error"] =
                detail.message; // Not properly supported yet
            pi.invalid = true;
          } else {
            window.alert("Unknown control: " + input.runtimeType.toString());
          }
        } else {
          showMessage(detail.message, "error");
        }
      } else {
        showMessage(detail.message, "error");
      }
    }
  }

  void showMessage(String message, [String severity]) {
    mainApp.showMessage(message, severity);
  }
}
