part of controls;

class AControl extends PolymerElement  {
  MainApp _mainApp = null;
  MainApp get mainApp  {
    if(_mainApp==null) {
      _mainApp = getParentElement(this.parent, "main-app");
      if(_mainApp==null)
        throw new Exception("Main app element could not be found");
    }
    return _mainApp;
  }

  DartalogApi api;

  AControl.created() : super.created();

  Future activate(DartalogApi api, Map args) async {
    this.api = api;
    await activateInternal(args);
  }

  Future activateInternal(Map args);

  @reflectable
  paperDialogCancelClicked(event, [_]) {
    PaperDialog pd = getParentElement(event.target, "paper-dialog");
    if(pd!=null)
      pd.cancel();
  }

  void clearValidation() {
  }

  void handleException(e, st) {
    mainApp.handleException(e,st);
  }

  void showMessage(String message, [String severity]) {
    mainApp.showMessage(message, severity);;
  }


  void handleApiError(commons.DetailedApiRequestError error, {String generalErrorField: "", String prefix: "input_"}) {
    clearValidation();
    if(generalErrorField.length>0) {
      dynamic input = $[generalErrorField];
      if(input!=null) {
        input.text = error.message;
      } else {
        showMessage(error.message, "error");
      }
    } else {
      showMessage(error.message, "error");
    }
    setErrorMesage(error.errors, prefix: prefix);
  }

  void setErrorMesage(List<commons.ApiRequestErrorDetail> fieldErrors, {String prefix: "input_"}) {
    for(commons.ApiRequestErrorDetail detail in fieldErrors) {
      if(detail.message==null||detail.message.length==0)
        continue;


      if(detail.locationType=="field") {
        dynamic input = $[prefix + detail.location];

        if(input!=null) {
          if(input is PaperInputBehavior) {
            PaperInputBehavior pi = input as PaperInputBehavior;
            pi.errorMessage = detail.message;
            pi.invalid = true;
          } else if(input is PaperDropdownMenu) {
            PaperDropdownMenu pi = input as PaperDropdownMenu;
            pi.attributes["error"] = detail.message; // Not properly supported yet
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
}