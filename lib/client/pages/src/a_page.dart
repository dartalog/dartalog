part of pages;


abstract class APage extends PolymerElement {
  APage.created(this.title) : super.created();

  DartalogApi api;

  @property String title;

  void activate(DartalogApi api, Map args) {
    this.api = api;
    activateInternal(args);
  }
  void activateInternal(Map args);

  void clearValidation() {

  }

  void handleApiError(DetailedApiRequestError error, {String generalErrorField: "", String prefix: "input_"}) {
    clearValidation();
    if(generalErrorField.length>0) {
      dynamic input = $[generalErrorField];
      if(input!=null) {
        input.text = error.message;
      } else {
        window.alert(error.message);
      }
    } else {
      window.alert(error.message);
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
          window.alert(detail.message);
        }
      } else {
        window.alert(detail.message);
      }
    }

  }
}