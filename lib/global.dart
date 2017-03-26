import 'tools.dart';
export 'src/exceptions/forbidden_exception.dart';
export 'src/exceptions/invalid_input_exception.dart';
export 'src/exceptions/not_found_exception.dart';
export 'src/exceptions/validation_exception.dart';
export 'src/item_action.dart';
export 'src/item_status.dart';
export 'src/user_privilege.dart';

const String appName = "Dartalog";
const String itemApiVersion = "0.1";
const String itemApiName = "item";
const String itemApiPath = "api/$itemApiName/$itemApiVersion/";

const int DEFAULT_PER_PAGE = 60;

const String fileUploadPrefix =
    "upload:"; // Chosen because it easily subdivides into the most digits
const String HOSTED_IMAGE_PREFIX = "image:";

const String HOSTED_IMAGES_ORIGINALS_PATH = "${HOSTED_IMAGES_PATH}originals/";
const String HOSTED_IMAGES_PATH = "images/";

const String HOSTED_IMAGES_THUMBNAILS_PATH = "${HOSTED_IMAGES_PATH}thumbnails/";
const int HTTP_STATUS_SERVER_NEEDS_SETUP = 555;

const int PAGINATED_DATA_LIMIT = 60;


const String numericFieldTypeId = "numeric";
const String stringFieldTypeId = "string";
const String dateFieldTypeId = "date";
const String imageFieldTypeId = "image";
const String hiddenFieldTypeId = "hidden";
const String multiValueStringTypeID = "multiValueString";

final Map<String, String> globalFieldTypes = {
  numericFieldTypeId: 'Numeric',
  stringFieldTypeId: 'String',
  dateFieldTypeId: 'Date',
  imageFieldTypeId: 'Image',
  hiddenFieldTypeId: 'Hidden',
  multiValueStringTypeID: "Multi-value String",
};

final RegExp FILE_UPLOAD_REGEX = new RegExp("$fileUploadPrefix(\\d+)");

final List<String> _reservedWords = <String>[
  'id',
  'name',
  'title',
  'search',
  'edit',
  'add',
];

bool isReservedWord(String input) =>
    _reservedWords.contains(input.trim().toLowerCase());

//class Guid {
//  List<int> data;
//
//  Guid(this.data);
//
//  @override
//  String toString() {
//    return formatUuid(this.data.map<String>((int i) => i.toRadixString(16)).join());
//  }
//}