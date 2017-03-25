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

abstract class APage extends AErrorThing {

  bool processing = false;

  final PageControlService _pageControl;
  final AuthenticationService _auth;
  final Router _router;

  APage(this._pageControl, this._auth, this._router);
  bool get hasErrorMessage => StringTools.isNotNullOrWhitespace(errorMessage);

  void handleException(dynamic e, dynamic st) {
    loggerImpl.severe("handleException", e, st);
    errorMessage = e.toString();
  }

  Future<dynamic> performApiCall(toAwait(), {NgForm form: null}) async {
    try {
      errorMessage = "";
      processing = true;
      return await toAwait();
    } on DetailedApiRequestError catch (e, st) {
      loggerImpl.severe(e, st);
      await _handleApiError(e, st, form);
    } catch (e, st) {
      setErrorMessage(e,st);
    } finally {
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
        await this._auth.clear();
        this._auth.promptForAuthentication();
      } else if (error.status == 413) {
        errorMessage =
        "The submitted data was too large, please submit smaller images";
      } else if (error.status == HTTP_STATUS_SERVER_NEEDS_SETUP) {} else {
        errorMessage = "${error.message} (${error.status})";
        await _router.navigate([setupRoute.name]);
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
      form.errors[field] = message;
      errorMessage = message;
    }
  }
}
