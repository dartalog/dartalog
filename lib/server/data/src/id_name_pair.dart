import 'a_human_friendly_data.dart';
import 'package:rpc/rpc.dart';

@ApiMessage(includeSuper: true)
class IdNamePair extends AHumanFriendlyData {

  IdNamePair();

  IdNamePair.withValues(String uuid, String name, String readableId):
        super.withValues(name, readableId, uuid: uuid);

  IdNamePair.copy(dynamic o): super.copy(o);

  static List<IdNamePair> convertList(Iterable<dynamic> i) {
    final List<IdNamePair> output = new List<IdNamePair>();
    for (dynamic o in i) {
      output.add(new IdNamePair.copy(o));
    }
    return output;
  }

  static List<IdNamePair> copyList(Iterable<dynamic> i) {
    final List<IdNamePair> output = new List<IdNamePair>();
    for (dynamic o in i) {
      output.add(new IdNamePair.copy(o));
    }
    return output;
  }
}
