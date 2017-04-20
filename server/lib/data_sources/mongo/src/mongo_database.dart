import 'dart:async';

import 'package:connection_pool/connection_pool.dart';
import 'package:dartalog/model/model.dart';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'a_mongo_id_data_source.dart';
import 'constants.dart';
import 'mongo_db_connection_pool.dart';

class MongoDatabase {
  static final Logger _log = new Logger('_MongoDatabase');

  static const String _settingsCollection = "settings";
  static const String _itemsCollection = "items";
  static const String _fieldsCollection = "fields";
  static const String _itemTypesCollection = "itemTypes";
  static const String _collectionsCollection = "collections";
  static const String _usersCollection = "users";
  static const String _historyCollection = "itemCopyHistory";

  static const String redirectEntryName = "redirect";
  static const int maxConnections = 3;

  final Db db;

  MongoDatabase(this.db);

  void checkForRedirectMap(Map data) {
    if (data.containsKey(redirectEntryName)) {
      throw new Exception("Not inplemented"); //TODO: Implement!
      //throw new api.RedirectingException(data["id"], data[REDIRECT_ENTRY_NAME]);
    }
  }

  Map createRedirectMap(String oldUuid, String newUuid) {
    return {"uuid": oldUuid, redirectEntryName: newUuid};
  }

  Future<DbCollection> getCollectionsCollection() async {
    return await getHumanReadableCollection(_collectionsCollection);
  }

  Future<DbCollection> getFieldsCollection() async {
    return await getHumanReadableCollection(_fieldsCollection);
  }

  Future<DbCollection> getHumanReadableCollection(String collectionName) async {
      final DbCollection output = await getUuidCollection(collectionName);
      await db.createIndex(collectionName,
      keys: {readableIdField: 1}, name: "ReadableIdIndex", unique: true);
      return output;
  }

  Future<DbCollection> getItemCopyHistoryCollection() async {
    final DbCollection output = db.collection(_historyCollection);
    await db.createIndex(_historyCollection,
        keys: {itemCopyUuidField: 1}, name: "ItemCopyUuidIndex");
    return output;
  }

  Future<DbCollection> getItemsCollection() async {
    final DbCollection output =
        await getHumanReadableCollection(_itemsCollection);
    await db.createIndex(_itemsCollection,
        keys: {r"$**": "text"}, name: "TextIndex");
    await db.createIndex(_itemsCollection,
        key: itemCopyUniqueIdPath,
        unique: true,
        sparse: true,
        name: "UniqueIdIndex");
    await db.createIndex(_itemsCollection,
        key: itemCopyUuidPath,
        unique: true,
        sparse: true,
        name: "ItemCopyUuidIndex");
    return output;
  }

  Future<DbCollection> getItemTypesCollection() async {
    return await getHumanReadableCollection(_itemTypesCollection);
  }

  Future<DbCollection> getSettingsCollection() async {
    final DbCollection output = db.collection(_settingsCollection);
    return output;
  }

  Future<DbCollection> getTransactionsCollection() async {
    final DbCollection output = db.collection("transactions");
    return output;
  }

  Future<DbCollection> getUsersCollection() async {
    final DbCollection output = await getUuidCollection(_usersCollection);
    await db.createIndex(_usersCollection,
        keys: {"id": "text", "name": "text"}, name: "TextIndex");
    return output;
  }

  Future<DbCollection> getUuidCollection(String collectionName) async {
    await db.createIndex(collectionName,
        keys: {uuidField: 1}, name: "UuidIndex", unique: true);
    return db.collection(collectionName);
  }

  Future<Null> nukeDatabase() async {
    final DbCommand cmd = DbCommand.createDropDatabaseCommand(db);
    await db.executeDbCommand(cmd);
  }

  Future<Null> startTransaction() async {
    final DbCollection transactions = await getTransactionsCollection();
    await transactions.findOne({"state": "initial"});
  }

}
