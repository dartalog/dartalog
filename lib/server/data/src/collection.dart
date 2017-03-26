import 'a_human_friendly_data.dart';

import 'package:rpc/rpc.dart';
@ApiMessage(includeSuper: true)
class Collection extends AHumanFriendlyData {
  bool publiclyBrowsable = false;

  List<String> curatorUuids = <String>[];
  List<String> browserUuids = <String>[];

  Collection();


}
