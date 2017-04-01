import '../data.dart';
import 'src/fields.dart';
import 'src/item_types.dart';

export 'src/fields.dart';
export 'src/item_types.dart';

final UuidDataList<Field> fieldTemplates = new UuidDataList<Field>.copy([
  asinField,
  authorField,
  backCoverField,
  frontCoverField,
  gamePlatformField,
  illustratorField,
  isbn10Field,
  isbn13Field,
  issueField,
  mobygamesIdField,
  seriesField,
  synopsisField,
  upcField,
  volumeField,
]);

final UuidDataList<ItemType> itemTypeTemplates = new UuidDataList<ItemType>.copy([
  bookItemType,
  comicBookItemType,
  blurayItemType,
  dvdItemType,
  videoGameItemType
]);
