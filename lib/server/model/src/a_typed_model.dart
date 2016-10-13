import 'dart:async';
import 'package:dartalog/server/data/data.dart';

import 'a_model.dart';

abstract class ATypedModel<T> extends AModel {
  Future validate(T t, bool creating) =>
      DataValidationException.PerformValidation((Map output) async =>
          output.addAll(await validateFields(t, creating)));

  @override
  Future<Map<String, String>> validateFields(T t, bool creating);
}
