import 'a_id_data.dart';

import 'package:rpc/rpc.dart';
@ApiMessage(includeSuper: true)
class Collection extends AIdData {
  bool publiclyBrowsable = false;

  List<String> curators = <String>[];
  List<String> browsers = <String>[];

  Collection();


}
