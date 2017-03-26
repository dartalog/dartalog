import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:option/option.dart';
import 'a_data_source.dart';

abstract class AItemCopyDataSource extends ADataSource {
  static final Logger _log = new Logger('AItemCopyModel');

  Future<Null> deleteByCollection(String collectionUuid);
  Future<Option<ItemCopy>> getByUniqueId(String uniqueId);
  Future<Option<ItemCopy>> getByUuid(String uuid);
  Future<bool> existsByUniqueId(String uniqueId);
  Future<List<ItemCopy>> getAllForItem(String itemUuid);
  Future<List<ItemCopy>> getVisibleForItem(String itemUuid, String userUuid);

  Future<List<ItemCopy>> getAll(List<String> itemCopyUuids);
  Future<Null> updateStatus(List<String> itemCopyUuids, String status);
  Future<Null> updateCollection(List<String> itemCopyUuids, String status);
}
