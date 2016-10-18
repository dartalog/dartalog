import 'package:dartalog/server/data/data.dart';
import 'package:rpc/rpc.dart';

class CreateItemRequest {
  Item item;
  List<MediaMessage> files = new List<MediaMessage>();

  String collectionId;
  String uniqueId;

  CreateItemRequest();
}
