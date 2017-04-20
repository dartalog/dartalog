import 'dart:async';

abstract class AFileUploadModel<T> {
  Future<String> create(T t, {List<List<int>> files});
  Future<String> update(String uuid, T t,
      {List<List<int>> files, bool bypassAuthentication: false});
}
