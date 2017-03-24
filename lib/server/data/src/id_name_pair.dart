import 'a_id_data.dart';
import 'package:rpc/rpc.dart';

@ApiMessage(includeSuper: true)
class IdNamePair extends AIdData {

  IdNamePair();

  IdNamePair.withValues(String id, String name, String readableId):
        super.withValues(id,name, readableId);

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
