import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:option/option.dart';
import 'a_data_source.dart';

abstract class AItemCopyDataSource extends ADataSource {
  static final Logger _log = new Logger('AItemCopyModel');

  Future<Null> delete(String itemId, int copy);
  Future<Option<ItemCopy>> getByItemIdAndCopy(String itemId, int copy);
  Future<bool> existsByItemIdAndCopy(String itemId, int copy);
  Future<Option<ItemCopy>> getByUniqueId(String uniqueId);
  Future<bool> existsByUniqueId(String uniqueId);
  Future<List<ItemCopy>> getAllForItemId(String itemId);
  Future<List<ItemCopy>> getVisibleForItemId(String itemId, String userName);
  Future<ItemCopyId> write(ItemCopy itemCopy, bool update);
  Future<int> getNextCopyNumber(String itemId);
  Future<List<ItemCopy>> getAll(List<ItemCopyId> itemCopies);

  Future<Null> updateStatus(List<ItemCopyId> itemCopies, String status);
  Future<Null> updateCollection(List<ItemCopyId> itemCopies, String status);
}
