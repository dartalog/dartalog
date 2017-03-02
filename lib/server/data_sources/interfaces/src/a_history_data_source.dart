import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog/server/data/data.dart';
import 'a_data_source.dart';

abstract class AHistoryDataSource extends ADataSource {
  static final Logger _log = new Logger('AItemCopyHistoryModel');

  Future<List<AHistoryEntry>> getForItemCopy(String itemId, int copy);
  Future<Null> write(AHistoryEntry historyEntry);
}
