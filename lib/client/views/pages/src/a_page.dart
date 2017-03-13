import 'package:angular2/angular2.dart';
import 'dart:async';
import 'package:dartalog/client/api/api.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:logging/logging.dart';

abstract class APage {
  String errorMessage = "";
  bool processing = false;
  Logger get loggerImpl;

  final PageControlService _pageControl;

  APage(this._pageControl);

  Future<dynamic> performApiCall(toAwait(), [NgForm form = null]) async {
    try {
      processing = true;
      return await toAwait();
    } on DetailedApiRequestError catch (e, st) {
      await _handleApiError(e, st);
    } catch (e, st) {
      errorMessage = e.message;
    } finally {
      processing = false;
    }
  }

  bool _handleErrorDetail(ApiRequestErrorDetail detail, [NgForm form = null]) {
    if (detail.locationType == "field"&&form!=null) {
      _setFieldMessage(form, detail.location, detail.message);
      return true;
    } else {
      errorMessage = detail.message;
      return false;
    }
  }

  void _setFieldMessage(NgForm form, String field, String message) {
    if(form.controls.containsKey(field)) {
      final AbstractControl control = form.controls[field];
      control.errors["error"] = message;
    } else {
      form.errors["error"] = message;
      errorMessage = message;
    }
  }


  void _handleErrorDetails(List<ApiRequestErrorDetail> fieldErrors) {
    for (ApiRequestErrorDetail detail in fieldErrors) {
      if (detail.message == null || detail.message.length == 0) continue;
      final bool result = _handleErrorDetail(detail);
    }
  }

  Future<Null> _handleApiError(
      DetailedApiRequestError error, dynamic st) async {
    try {
//      clearValidation();
      if (error.status == 400) {
        if (!_handleErrorDetails(error.errors))
          errorMessage = error.message;
      } else if (error.status == 401) {
        await this._mainApp.clearAuthentication();
        await this._mainApp.promptForAuthentication();
        await this._mainApp.evaluateAuthentication();
      } else if (error.status == 413) {
         errorMessage = "The submitted data was too large, please submit smaller images";
      } else {
        errorMessage =
            "API Error: ${error.message} (${error.status})";
      }
    } catch (e, st) {
      loggerImpl.severe(e, st);
      this._handleException(e, st);
    }
  }


}