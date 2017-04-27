import 'a_human_friendly_data.dart';
import 'item_copy.dart';
import 'item_type.dart';
import 'package:option/option.dart';
import 'tag_category.dart';
import 'package:rpc/rpc.dart';

@ApiMessage(includeSuper: true)
class Tag extends AHumanFriendlyData {
  String categoryUuid;
  TagCategory category;
}

