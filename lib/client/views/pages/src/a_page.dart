import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:dartalog/client/api/api.dart';
import 'package:dartalog/client/services/services.dart';
import 'package:logging/logging.dart';
import 'dart:html';
import 'package:dartalog/tools.dart';

abstract class APage {
  String errorMessage = "";

  bool get hasErrorMessage =>StringTools.isNotNullOrWhitespace(errorMessage);

  bool processing = false;
  final PageControlService _pageControl;

  final AuthenticationService _auth;
  APage(this._pageControl, this._auth);

  Logger get loggerImpl;

  Future<dynamic> performApiCall(toAwait(), {NgForm form: null}) async {
    try {
      errorMessage = "";
      processing = true;
      return await toAwait();
    } on DetailedApiRequestError catch (e, st) {
      await _handleApiError(e, st, form);
    } catch (e, st) {
      errorMessage = e.message;
    } finally {
      processing = false;
    }
  }

  Future<Null> _handleApiError(
      DetailedApiRequestError error, dynamic st, [NgForm form = null]) async {
    try {
//      clearValidation();
      if (error.status == 400) {
        _handleErrorDetails(error.errors,form);
        errorMessage = error.message;
      } else if (error.status == 401) {
        await this._auth.clear();
        await this._auth.promptForAuthentication();
      } else if (error.status == 413) {
        errorMessage =
            "The submitted data was too large, please submit smaller images";
      } else {
        errorMessage = "${error.message} (${error.status})";
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

  void _handleErrorDetails(List<ApiRequestErrorDetail> fieldErrors, [NgForm form = null]) {
    for (ApiRequestErrorDetail detail in fieldErrors) {
      if (detail.message == null || detail.message.length == 0) continue;
      _handleErrorDetail(detail, form);
    }
  }

  void handleException(dynamic e, dynamic st) {
    loggerImpl.severe("handleException", e, st);
    errorMessage = e.toString();
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
