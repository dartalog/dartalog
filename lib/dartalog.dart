library dartalog;

part 'src/not_found_exception.dart';
part 'src/not_authorized_exception.dart';
part 'src/invalid_input_exception.dart';

const String LOGGED_IN_USER = 'sanmadjack';

const String FILE_UPLOAD_PREFIX = "upload:";
const String HOSTED_IMAGE_PREFIX = "image:";

const String HOSTED_IMAGES_PATH = "images/";
const String HOSTED_IMAGES_ORIGINALS_PATH = "${HOSTED_IMAGES_PATH}originals/";
const String HOSTED_IMAGES_THUMBNAILS_PATH = "${HOSTED_IMAGES_PATH}thumbnails/";

final Map<String, String> FIELD_TYPES = {
  'numeric': 'Numeric',
  'string': 'String',
  'date': 'Date',
  'image': 'Image',
  'hidden': 'Hidden'
};

final RegExp FILE_UPLOAD_REGEX = new RegExp("${FILE_UPLOAD_PREFIX}(\\d+)");

const String ITEM_ACTION_BORROW = "borrow";
const String ITEM_ACTION_RETURN = "return";
const String ITEM_ACTION_REMOVE = "remove";
const String ITEM_ACTION_MARK_AS_LOST = "mark_as_lost";

const String ITEM_STATUS_AVAILABLE = 'available';
const String ITEM_STATUS_BORROWED = 'borrowed';
const String ITEM_STATUS_REMOVED = 'removed';
const String ITEM_STATUS_LOST = 'lost';

const String ITEM_DEFAULT_STATUS = ITEM_STATUS_AVAILABLE;

final Map<String, String> ITEM_COPY_STATUSES = {
  ITEM_STATUS_BORROWED: 'Borrowed',
  ITEM_STATUS_LOST: 'Lost',
  ITEM_STATUS_AVAILABLE: 'Available'
};

final Map<String, ItemAction> ITEM_ACTIONS = {
  ITEM_ACTION_BORROW: new ItemAction(ITEM_ACTION_BORROW, "Borrow", [ITEM_STATUS_AVAILABLE], ITEM_STATUS_BORROWED),
  ITEM_ACTION_RETURN: new ItemAction(ITEM_ACTION_RETURN, "Return", [ITEM_STATUS_BORROWED], ITEM_STATUS_AVAILABLE),
  ITEM_ACTION_REMOVE: new ItemAction(ITEM_ACTION_REMOVE, "Remove", [ITEM_STATUS_AVAILABLE], ITEM_STATUS_REMOVED),
  ITEM_ACTION_MARK_AS_LOST: new ItemAction(ITEM_ACTION_MARK_AS_LOST, "Mark As Lost", [ITEM_STATUS_AVAILABLE, ITEM_STATUS_BORROWED], ITEM_STATUS_LOST)
};

class ItemAction {
  String id;
  String name;
  List<String> validStatuses;
  String resultingStatus;

  ItemAction(this.id, this.name, this.validStatuses, this.resultingStatus);
}



final List<String> RESERVED_WORDS = ['id', 'name', 'title'];

class ValidationException implements Exception {
  String message;
  ValidationException(this.message);
}
