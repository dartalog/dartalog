export 'src/exceptions/forbidden_exception.dart';
export 'src/exceptions/invalid_input_exception.dart';
export 'src/exceptions/not_found_exception.dart';
export 'src/exceptions/validation_exception.dart';

const String API_PATH = "api/dartalog/0.1/";

const int DEFAULT_PER_PAGE = 60;

const String FILE_UPLOAD_PREFIX =
    "upload:"; // Chosen because it easily subdivides into the most digits
const String HOSTED_IMAGE_PREFIX = "image:";

const String HOSTED_IMAGES_ORIGINALS_PATH = "${HOSTED_IMAGES_PATH}originals/";
const String HOSTED_IMAGES_PATH = "images/";

const String HOSTED_IMAGES_THUMBNAILS_PATH = "${HOSTED_IMAGES_PATH}thumbnails/";
const int HTTP_STATUS_SERVER_NEEDS_SETUP = 555;
const String ITEM_ACTION_BORROW = "borrow";

const String ITEM_ACTION_MARK_AS_LOST = "mark_as_lost";

const String ITEM_ACTION_REMOVE = "remove";

const String ITEM_ACTION_RETURN = "return";
const String ITEM_DEFAULT_STATUS = ITEM_STATUS_AVAILABLE;
const String ITEM_STATUS_AVAILABLE = 'available';
const String ITEM_STATUS_BORROWED = 'borrowed';

const String ITEM_STATUS_LOST = 'lost';
const String ITEM_STATUS_REMOVED = 'removed';
const String LOGGED_IN_USER = 'sanmadjack';
const int PAGINATED_DATA_LIMIT = 60;

final Map<String, String> FIELD_TYPES = {
  'numeric': 'Numeric',
  'string': 'String',
  'date': 'Date',
  'image': 'Image',
  'hidden': 'Hidden'
};

final RegExp FILE_UPLOAD_REGEX = new RegExp("${FILE_UPLOAD_PREFIX}(\\d+)");

final Map<String, ItemAction> ITEM_ACTIONS = {
  ITEM_ACTION_BORROW: new ItemAction(ITEM_ACTION_BORROW, "Borrow",
      [ITEM_STATUS_AVAILABLE], ITEM_STATUS_BORROWED),
  ITEM_ACTION_RETURN: new ItemAction(ITEM_ACTION_RETURN, "Return",
      [ITEM_STATUS_BORROWED], ITEM_STATUS_AVAILABLE),
  ITEM_ACTION_REMOVE: new ItemAction(ITEM_ACTION_REMOVE, "Remove",
      [ITEM_STATUS_AVAILABLE], ITEM_STATUS_REMOVED),
  ITEM_ACTION_MARK_AS_LOST: new ItemAction(
      ITEM_ACTION_MARK_AS_LOST,
      "Mark As Lost",
      [ITEM_STATUS_AVAILABLE, ITEM_STATUS_BORROWED],
      ITEM_STATUS_LOST)
};

final Map<String, String> ITEM_COPY_STATUSES = {
  ITEM_STATUS_BORROWED: 'Borrowed',
  ITEM_STATUS_LOST: 'Lost',
  ITEM_STATUS_AVAILABLE: 'Available'
};

final List<String> RESERVED_WORDS = ['id', 'name', 'title', 'search'];

class ItemAction {
  String id;
  String name;
  List<String> validStatuses;
  String resultingStatus;

  ItemAction(this.id, this.name, this.validStatuses, this.resultingStatus);
}

class UserPrivilege {
  static const String none = "none";
  static const String authenticated = "authenticated";
  static const String patron = "patron";
  static const String checkout = "checkout";
  static const String curator = "curator";
  static const String admin = "admin"; // Implies all other privileges
  static final List values = [patron, checkout, curator, admin];

  static bool evaluate(String needed, String have) {
    if (needed == none) return true;

    if (!values.contains(needed))
      throw new Exception("User type ${needed} not recognized");
    if (!values.contains(have))
      throw new Exception("User type ${have} not recognized");
    return values.indexOf(needed) <= values.indexOf(have);
  }
}
