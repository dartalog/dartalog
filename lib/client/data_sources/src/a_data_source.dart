part of data_sources;

abstract class ADataSource {
  static const String _DARTALOG_IDB_NAME = "dartalog";
  static const int _DARTALOG_IDB_VERSION = 3;
  static const String _DARTALOG_IDB_SETTINGS_STORE = "settings";
  static const String _DARTALOG_IDB_CART_STORE = "cart";
  static const String READ_ONLY = "readonly";

  static const String READ_WRITE = 'readwrite';
  idb.Database _db;

  Future openIndexedDb() async {
    if (!idb.IdbFactory.supported)
      throw new Exception(
          "IndexedDb not suppored! Oh no!"); //TODO: Implement alternative auth caching mechanism

    if (_db == null)
      _db = await window.indexedDB.open(_DARTALOG_IDB_NAME,
          version: _DARTALOG_IDB_VERSION, onUpgradeNeeded: _onUpgradeNeeded);
  }

  void _onUpgradeNeeded(idb.VersionChangeEvent e) {
    idb.Database db = (e.target as idb.OpenDBRequest).result;
    if (!db.objectStoreNames.contains(_DARTALOG_IDB_SETTINGS_STORE)) {
      db.createObjectStore(_DARTALOG_IDB_SETTINGS_STORE, keyPath: 'id');
    }
    if (!db.objectStoreNames.contains(_DARTALOG_IDB_CART_STORE)) {
      db.createObjectStore(_DARTALOG_IDB_CART_STORE, keyPath: "id", autoIncrement: true);
    }
  }

  Future _wrapTransaction(String storeName, String mode,
      Future toAwait(idb.ObjectStore store)) async {
    await openIndexedDb();
    idb.Transaction trans = _db.transaction(storeName, mode);
    idb.ObjectStore store = trans.objectStore(storeName);

    return await toAwait(store);
  }
}
