import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'a_data_source.dart';

abstract class AItemCopyHistoryModel extends ADataSource {
  static final Logger _log = new Logger('AItemCopyHistoryModel');

  Future<List<ItemCopyHistoryEntry>> getForItemCopy(String itemId, int copy);
  Future write(ItemCopyHistoryEntry itemCopy);

}
