import 'package:option/option.dart';
import 'dart:async';
import 'dart:indexed_db' as idb;
import 'a_data_source.dart';
import 'package:angular2/core.dart';

@Injectable()
class SettingsService extends ADataSource {
  static const String authKeyName = "authKey";

  Future<Null> cacheAuthKey(String text) async {
    await wrapTransaction(
        ADataSource.idbSettingsStore, ADataSource.readWritePermission,
        (idb.ObjectStore store) async {
      await store.put(<String, String>{'id': authKeyName, 'value': text});
    });
  }

  Future<Null> clearAuthCache() async {
    await wrapTransaction(
        ADataSource.idbSettingsStore, ADataSource.readWritePermission,
        (idb.ObjectStore store) async {
      await store.delete(authKeyName);
    });
  }

  Future<Option<String>> getCachedAuthKey() async {
    return await wrapTransaction(
        ADataSource.idbSettingsStore, ADataSource.readOnlyPermission,
        (idb.ObjectStore store) async {
      final dynamic obj = await store.getObject(authKeyName);
      if (obj == null) return new None<String>();
      return new Some<String>(obj["value"]);
    });
  }
}
