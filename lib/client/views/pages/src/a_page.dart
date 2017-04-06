import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:dartalog/client/api/api.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/tools.dart';
import 'package:angular2/router.dart';
import 'package:dartalog/client/routes.dart';
import '../../src/a_error_thing.dart';
import 'package:meta/meta.dart';

abstract class APage extends AErrorThing {
  bool processing = false;

  bool userAuthorized = false;

  final PageControlService _pageControl;
  @protected
  final AuthenticationService auth;
  final Router _router;

  APage(this._pageControl, this.auth, this._router);
  bool get hasErrorMessage => StringTools.isNotNullOrWhitespace(errorMessage);

  void handleException(dynamic e, dynamic st) {
    loggerImpl.severe("handleException", e, st);
    errorMessage = e.toString();
  }

  Future<dynamic> performApiCall(Future<Null> toAwait(), {NgForm form: null , Future<Null> after(): null}) async {
    try {
      errorMessage = "";
      processing = true;
      return await toAwait();
    } on DetailedApiRequestError catch (e, st) {
      loggerImpl.severe(e, st);
      await _handleApiError(e, st, form);
    } catch (e, st) {
      setErrorMessage(e, st);
    } finally {
      if(after!=null)
        await after();
      processing = false;
    }
  }

  Future<Null> _handleApiError(DetailedApiRequestError error, dynamic st,
      [NgForm form = null]) async {
    try {
//      clearValidation();
      if (error.status == 400) {
        _handleErrorDetails(error.errors, form);
        errorMessage = error.message;
      } else if (error.status == 401) {
        await this.auth.clear();
        this.auth.promptForAuthentication();
      } else if (error.status == 413) {
        errorMessage =
            "The submitted data was too large, please submit smaller images";
      } else if (error.status == httpStatusServerNeedsSetup) {
        loggerImpl.warning("Server replied that setup is required", error, st);
        await _router.navigate([setupRoute.name]);
      } else {
        errorMessage = "Server error: ${error.message} (${error.status})";
      }
    } catch (e, st) {
      loggerImpl.severe(e, st);
      this.handleException(e, st);
    }
  }

  void _handleErrorDetail(ApiRequestErrorDetail detail, [NgForm form = null]) {
    if (detail.locationType == "field" && form != null) {
      _setFieldMessage(form, detail.location, detail.message);
    } else {
      errorMessage = detail.message;
    }
  }

  void _handleErrorDetails(List<ApiRequestErrorDetail> fieldErrors,
      [NgForm form = null]) {
    for (ApiRequestErrorDetail detail in fieldErrors) {
      if (detail.message == null || detail.message.length == 0) continue;
      _handleErrorDetail(detail, form);
    }
  }

  void _setFieldMessage(NgForm form, String field, String message) {
    if (form.controls.containsKey(field)) {
      final AbstractControl control = form.controls[field];
      control.setErrors({field: message});
    } else {
      throw new NotFoundException("Can't find field for $field");
      //form.errors[field] = message;
      //errorMessage = message;
    }
  }
}
