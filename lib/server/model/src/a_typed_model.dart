import 'dart:async';
import 'package:dartalog/server/data/data.dart';

import 'a_model.dart';
import 'package:meta/meta.dart';

abstract class ATypedModel<T> extends AModel {
  Future validate(T t, {String existingId: null}) =>
      DataValidationException.performValidation((Map output) async =>
          output.addAll(await validateFields(t, existingId: existingId)));

  @protected
  Future<Map<String, String>> validateFields(T t, {String existingId: null});
}
