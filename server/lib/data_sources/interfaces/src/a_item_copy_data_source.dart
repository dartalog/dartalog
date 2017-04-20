import 'dart:async';

import 'package:dartalog/data/data.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';

import 'a_data_source.dart';
import 'a_uuid_based_data_source.dart';

abstract class AItemCopyDataSource extends AUuidBasedDataSource<ItemCopy> {
  static final Logger _log = new Logger('AItemCopyModel');

  Future<Null> deleteByCollection(String collectionUuid);
  Future<bool> existsByUniqueId(String uniqueId);
  Future<List<ItemCopy>> getAllByUuids(List<String> itemCopyUuids);
  Future<List<ItemCopy>> getByItemUuid(String itemUuid);
  Future<Option<ItemCopy>> getByUniqueId(String uniqueId);
  Future<List<ItemCopy>> getVisibleForItem(String itemUuid, String userUuid);
  Future<Null> updateCollection(List<String> itemCopyUuids, String status);
  Future<Null> updateStatus(List<String> itemCopyUuids, String status);
}
