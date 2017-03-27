const String TEXT_COMMAND = "\$text";
const String UNWIND_COMMAND = "\$unwind";
const String MATCH_COMMAND = "\$match";
const String PROJECT_COMMAND = "\$project";
const String SEARCH_COMMAND = "\$search";

const String uuidField = "uuid";
const String nameField = "name";
const String readableIdField = "readableId";
const String collectionUuidField = "collectionUuid";
const String typeUuidField = "typeUuid";

const String itemCopiesField = "copies";
const String uniqueIdField = "uniqueId";
const String itemCopyHistoryField = "history";
const String itemCopyUuidField = "itemCopyUuid";

const String itemCopyCollectionPath = "$itemCopiesField.$collectionUuidField";

const String itemCopyUniqueIdPath = "$itemCopiesField.$uniqueIdField";
const String itemCopyUuidPath = "$itemCopiesField.$uuidField";
