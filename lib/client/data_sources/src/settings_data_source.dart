import 'package:option/option.dart';
import 'dart:async';
import 'dart:indexed_db' as idb;
import 'a_data_source.dart';

class SettingsDataSource extends ADataSource {
  static const String AUTH_KEY_NAME = "authKey";

  Future cacheAuthKey(String text) async {
    await wrapTransaction(
        ADataSource.DARTALOG_IDB_SETTINGS_STORE, ADataSource.READ_WRITE,
        (idb.ObjectStore store) async {
      await store.put({'id': AUTH_KEY_NAME, 'value': text});
    });
  }

  Future clearAuthCache() async {
    await wrapTransaction(
        ADataSource.DARTALOG_IDB_SETTINGS_STORE, ADataSource.READ_WRITE,
        (idb.ObjectStore store) async {
      await store.delete(AUTH_KEY_NAME);
    });
  }

  Future<Option<String>> getCachedAuthKey() async {
    return await wrapTransaction(
        ADataSource.DARTALOG_IDB_SETTINGS_STORE, ADataSource.READ_ONLY,
        (idb.ObjectStore store) async {
      dynamic obj = await store.getObject(AUTH_KEY_NAME);
      if (obj == null) return new None();
      Option output = new Some(obj["value"]);
      return output;
    });
  }
}
