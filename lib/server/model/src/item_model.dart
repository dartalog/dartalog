part of model;

class ItemModel extends AIdNameBasedModel<Item> {
  static final Logger _log = new Logger('ItemModel');
  Logger get _logger => _log;

  data_sources.AIdNameBasedDataSource<Item> get dataSource => data_sources.items;

  static final RegExp LEGAL_ID_CHARACTERS = new RegExp("[a-zA-Z0-9_]");

  final ItemCopyModel copies = new ItemCopyModel();

  @override
  Future<Item> getById(String id, {bool includeType: false, bool includeFields: false, bool includeCopies:false}) async {
    Item output = await super.getById(id);

      if (includeType) {
        output.type = await data_sources.itemTypes.getById(output.typeId);
        if (output.type == null) {
          throw new Exception(
              "Item type '${output.typeId}' specified for item not found");
        }
        if (includeFields) {
          output.type.fields =
          await data_sources.fields.getByIds(output.type.fieldIds);
        }
      } else if(includeFields) {
        throw new InvalidInputException(
            "Cannot include fields without including the type");
      }
      if (includeCopies) {
        output.copies = await this.copies.getAllForItem(id);
      }
    return output;
  }


  @override
  Future<String> create(Item item) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }
    if(!isNullOrWhitespace(item.getName))
      item.getId = await _generateUniqueId(item);
    return await super.create(item);
  }

  @override
  Future<String> update(String id, Item item) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }
    if(!isNullOrWhitespace(item.getName)) {
      Item oldItem = await data_sources.items.getById(id);
      if (oldItem == null)
        throw new NotFoundException("Item ${item} not found");

      if (oldItem.getName.trim().toLowerCase() != item.getName.trim().toLowerCase())
        item.getId = await _generateUniqueId(item);
    }

    return await super.update(id, item);
  }


  @override
  Future<Map<String, String>> _validateFieldsInternal(Item item) async {
    Map<String, String> field_errors = new Map<String, String>();

    //TODO: add dynamic field validation

    if (isNullOrWhitespace(item.typeId))
      field_errors["typeId"] = "Required";
    else {
      dynamic test = await data_sources.itemTypes.getById(item.typeId);
      if(test==null)
        field_errors["typeId"] = "Not found";
    }

    return field_errors;
  }


  static final List<String> NON_SORTING_WORDS = ["the", "a", "an"];

  static Future<String> _generateUniqueId(Item item) async {
    if (isNullOrWhitespace(item.getName))
      throw new InvalidInputException(
          "Name required to generate unique ID");

    StringBuffer output = new StringBuffer();
    String lastChar = "_";
    String name = item.getName.trim().toLowerCase();
    String first_word = name.split(" ")[0];
    if(NON_SORTING_WORDS.contains(first_word))
      name = name.substring(name.indexOf(" ")+1,name.length);

    for (int i = 0; i < name.length; i++) {
      String char = name.substring(i, i + 1);
      switch (char) {
        case " ":
        case ":":
          if (lastChar != "_") {
            lastChar = "_";
            output.write(lastChar);
          }
          break;
        default:
          if (LEGAL_ID_CHARACTERS.hasMatch(char)) {
            lastChar = char.toLowerCase();
            output.write(lastChar);
          }
          break;
      }
    }

    if (output.length == 0)
      throw new InvalidInputException(
          "Could not generate safe ID from name '${item.getName}'");

    String base_name = output.toString();
    String testName = base_name;
    Item testItem = await data_sources.items.getById(base_name);
    int i = 1;
    while (testItem != null) {
      testName = "${base_name}_${i}";
      i++;
      testItem = await data_sources.items.getById(testName);
    }
    return testName;
  }

  Future _handleFileUploads(Item item) async {
    ItemType type = await data_sources.itemTypes.getById(item.typeId);
    List<Field> fields = await data_sources.fields.getByIds(type.fieldIds);
    Map<String, List<int>> filesToWrite = new Map<String, List<int>>();

    for (Field f in fields) {
      if (f.type != "image" ||
          !item.values.containsKey(f.getId) ||
          isNullOrWhitespace(item.values[f.getId])) continue;

      //TODO: Old image cleanup

      String value = item.values[f.getId];

      if (value.startsWith(HOSTED_IMAGE_PREFIX)) {
        // This should indicate that the submitted image is one that is already hosted on the server, so nothing to do here
        continue;
      }

      List<int> data;

      Match m = FILE_UPLOAD_REGEX.firstMatch(value);
      if (m != null) {
        // This is a new file upload
        int filePosition = int.parse(m.group(1));
        if (item.fileUploads.length - 1 < filePosition) {
          throw new InvalidInputException("Field ${f.getId} specifies unprovided upload file at position ${filePosition}");
        }
        data = BASE64.decode(item.fileUploads[filePosition]);

        continue;
      } else {
        // So we assume it's a URL
        Uri fileUri = Uri.parse(value);
        HttpClientRequest req = await new HttpClient().getUrl(fileUri);
        HttpClientResponse response = await req.close();
        List<List<int>> output = await response.toList();
        data = new List<int>();
        for (List<int> chunk in output) {
          data.addAll(chunk);
        }
      }

      if (data.length == 0)
        throw new InvalidInputException("Specified file upload ${value} is empty");

      Digest hash = sha256.convert(data);
      String hashString = hash.toString();
      filesToWrite[hashString] = data;
      item.values[f.getId] = "${HOSTED_IMAGE_PREFIX}${hashString}";
    }

    // Now that the above sections have completed gathering all the file data_sources for saving, we save it all
    List<String> filesWritten = new List<String>();
    try {
      for (String key in filesToWrite.keys) {
        File file = new File(path.join(ROOT_DIRECTORY, "images", key));
        bool fileExists = await file.exists();
        if (!fileExists) {
          await file.create();
        }

        RandomAccessFile raf = await file.open(mode: FileMode.WRITE_ONLY);
        try {
          raf.writeFrom(filesToWrite[key]);
          filesWritten.add(file.path);
        } finally {
          try {
            await raf.close();
          } catch (e2, st) {}
        }
      }
    } catch (e, st) {
      _log.severe(e.message, e, st);
      for (String f in filesWritten) {
        try {
          File file = new File(f);
          bool exists = await file.exists();
          if (exists) await file.delete();
        } catch (e, st) {}
      }
      throw e;
    }
  }


}