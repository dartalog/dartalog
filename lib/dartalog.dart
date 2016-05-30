library dartalog;

part 'src/not_found_exception.dart';
part 'src/invalid_input_exception.dart';

const String LOGGED_IN_USER = 'sanmadjack';

const String FILE_UPLOAD_PREFIX = "upload:";
const String HOSTED_IMAGE_PREFIX = "image:";

final Map<String, String> FIELD_TYPES = {
  'numeric': 'Numeric',
  'string': 'String',
  'date': 'Date',
  'image': 'Image',
  'hidden': 'Hidden'
};

final RegExp FILE_UPLOAD_REGEX = new RegExp("${FILE_UPLOAD_PREFIX}(\\d+)");

const String ITEM_ACTION_NAME = 'name';
const String ITEM_ACTION_RESULTING_STATUS = 'resultingStatus';
const String ITEM_ACTION_VALID_STATUSES = 'validStatuses';
final Map<String, Map> ITEM_ACTIONS = {
  'borrow': {
    ITEM_ACTION_NAME: 'Borrow',
    ITEM_ACTION_VALID_STATUSES: ['available'],
    ITEM_ACTION_RESULTING_STATUS: 'borrowed'
  },
  'return': {
    ITEM_ACTION_NAME: 'Return',
    ITEM_ACTION_VALID_STATUSES: ['borrowed'],
    ITEM_ACTION_RESULTING_STATUS: 'available'
  }
};

final Map<String, String> ITEM_COPY_STATUSES = {
  'borrowed': 'Borrowed',
  'lost': 'Lost',
  'available': 'Available'
};

final List<String> RESERVED_WORDS = ['id', 'name', 'title'];

class ValidationException implements Exception {
  String message;
  ValidationException(this.message);
}
