import 'package:dartalog/data/data.dart';
import 'package:rpc/rpc.dart';

class CreateItemRequest {
  Item item;
  List<MediaMessage> files = new List<MediaMessage>();

  String collectionUuid;
  String uniqueId;

  CreateItemRequest();
}
