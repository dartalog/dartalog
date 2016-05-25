part of pages;



abstract class APage extends PolymerElement {
  APage.created(this.title) : super.created();

  DartalogApi api;

  @Property(notify: true)
  String title;

  bool showBackButton = false;

  MainApp _mainApp = null;
  MainApp get mainApp  {
    if(_mainApp==null) {
      _mainApp = getParentElement(this.parent, "main-app");
      if(_mainApp==null)
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
  }

  void setTitle(String newTitle) {
    this.title = newTitle;
    set("title", newTitle);
    mainApp.evaluatePage();
  }

  void handleException(e, st) {
    mainApp.handleException(e,st);
  }

  void showMessage(String message, [String severity]) {
    mainApp.showMessage(message, severity);;
  }

  void handleApiError(DetailedApiRequestError error, {String generalErrorField: "", String prefix: "input_"}) {
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

  void setErrorMesage(List<ApiRequestErrorDetail> fieldErrors, {String prefix: "input_"}) {
    for(ApiRequestErrorDetail detail in fieldErrors) {
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