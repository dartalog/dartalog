export 'src/exceptions/forbidden_exception.dart';
export 'src/exceptions/invalid_input_exception.dart';
export 'src/exceptions/not_found_exception.dart';
export 'src/exceptions/validation_exception.dart';
export 'src/item_action.dart';
export 'src/item_status.dart';
export 'src/user_privilege.dart';

const String itemApiVersion = "0.1";
const String itemApiName = "item";
const String itemApiPath = "api/$itemApiName/$itemApiVersion/";

const int DEFAULT_PER_PAGE = 60;

const String FILE_UPLOAD_PREFIX =
    "upload:"; // Chosen because it easily subdivides into the most digits
const String HOSTED_IMAGE_PREFIX = "image:";

const String HOSTED_IMAGES_ORIGINALS_PATH = "${HOSTED_IMAGES_PATH}originals/";
const String HOSTED_IMAGES_PATH = "images/";

const String HOSTED_IMAGES_THUMBNAILS_PATH = "${HOSTED_IMAGES_PATH}thumbnails/";
const int HTTP_STATUS_SERVER_NEEDS_SETUP = 555;

const int PAGINATED_DATA_LIMIT = 60;

final Map<String, String> FIELD_TYPES = {
  'numeric': 'Numeric',
  'string': 'String',
  'date': 'Date',
  'image': 'Image',
  'hidden': 'Hidden'
};

final RegExp FILE_UPLOAD_REGEX = new RegExp("${FILE_UPLOAD_PREFIX}(\\d+)");

final List<String> _reservedWords = <String>[
  'id',
  'name',
  'title',
  'search',
  'edit'
];

bool isReservedWord(String input) =>
    _reservedWords.contains(input.trim().toLowerCase());
