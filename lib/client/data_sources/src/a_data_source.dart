import 'dart:html';
import 'dart:async';
import 'dart:indexed_db' as idb;
import 'package:meta/meta.dart';

abstract class ADataSource {
  static const String _rootIdbName = "dartalog";
  static const int _rootIdbVersion = 3;
  @protected
  static const String idbSettingsStore = "settings";
  @protected
  static const String idbCartStore = "cart";

  static const String readOnlyPermission = "readonly";
  static const String readWritePermission = 'readwrite';

  idb.Database _db;

  Future<Null> openIndexedDb() async {
    if (!idb.IdbFactory.supported)
      throw new Exception(
          "IndexedDb not suppored! Oh no!"); //TODO: Implement alternative auth caching mechanism

    if (_db == null)
      _db = await window.indexedDB.open(_rootIdbName,
          version: _rootIdbVersion, onUpgradeNeeded: _onUpgradeNeeded);
  }

  void _onUpgradeNeeded(idb.VersionChangeEvent e) {
    if (e.target is idb.OpenDBRequest) {
      final idb.OpenDBRequest request = e.target;
      final idb.Database db = request.result;
      if (!db.objectStoreNames.contains(idbSettingsStore)) {
        db.createObjectStore(idbSettingsStore, keyPath: 'id');
      }
      if (!db.objectStoreNames.contains(idbCartStore)) {
        db.createObjectStore(idbCartStore, keyPath: "id", autoIncrement: true);
      }
    }
  }

  @protected
  Future<dynamic> wrapTransaction(String storeName, String mode,
      Future<dynamic> toAwait(idb.ObjectStore store)) async {
    await openIndexedDb();
    final idb.Transaction trans = _db.transaction(storeName, mode);
    final idb.ObjectStore store = trans.objectStore(storeName);

    return await toAwait(store);
  }
}
