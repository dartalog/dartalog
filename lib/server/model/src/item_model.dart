part of model;

class ItemModel extends AIdNameBasedModel<Item> {
  static final Logger _log = new Logger('ItemModel');
  Logger get _logger => _log;

  AItemDataSource get dataSource => data_sources.items;

  static final RegExp LEGAL_ID_CHARACTERS = new RegExp("[a-zA-Z0-9_]");

  final ItemCopyModel copies = new ItemCopyModel();

  static final String ORIGINAL_IMAGE_PATH =  path.join(ROOT_DIRECTORY, HOSTED_IMAGES_ORIGINALS_PATH);
  static final String THUMBNAIL_IMAGE_PATH =  path.join(ROOT_DIRECTORY, HOSTED_IMAGES_THUMBNAILS_PATH);
  static final Directory ORIGINAL_IMAGE_DIR = new Directory(ORIGINAL_IMAGE_PATH);
  static final Directory THUMBNAIL_DIR = new Directory(THUMBNAIL_IMAGE_PATH);

  @override
  Future<Item> getById(String id,
      {bool includeType: false,
      bool includeFields: false,
      bool includeCopies: false}) async {
    Item output = await super.getById(id);

    if (includeType) {
      output.type = (await data_sources.itemTypes.getById(output.typeId))
          .getOrElse(() => throw new Exception(
              "Item type '${output.typeId}' specified for item not found"));

      if (includeFields) {
        output.type.fields =
            await data_sources.fields.getByIds(output.type.fieldIds);
      }
    } else if (includeFields) {
      throw new InvalidInputException(
          "Cannot include fields without including the type");
    }
    if (includeCopies) {
      if (output.copies == null)
        output.copies = await this.copies.getAllForItem(id);
    } else {
      output.copies = null;
    }
    return output;
  }

//  @override
//  _performAdjustments(Item item) {
//    // TODO: filter this down to just image fields?
//    for(String key in item.values.keys) {
//      item.values[key] = _handleImageLink(item.values[key]);
//    }
//  }

  Future<List<Item>> search(String query) => dataSource.search(query);

  Future<ItemCopyId> createWithCopy(Item item, String collectionId,
  {String uniqueId, List<List<int>> files}) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }

    if (!isNullOrWhitespace(item.getName))
      item.getId = await _generateUniqueId(item);
    await DataValidationException.PerformValidation((Map output) async {
      output.addAll(await _validateFields(item, true));
      if (isNullOrWhitespace(collectionId)) {
        output["collectionId"] = "Required";
      } else if (!await data_sources.itemCollections.exists(collectionId)) {
        output["collectionId"] = "Invalid";
      }

      if (!isNullOrWhitespace(uniqueId) &&
          await data_sources.itemCopies.existsByUniqueId(uniqueId)) {
        output["uniqueId"] = "Already in use";
      }
      return output;
    });

    await _handleFileUploads(item, files);
    //TODO: More thorough cleanup of files in case of failure

    String itemId = await data_sources.items.write(item);
    ItemCopy itemCopy = new ItemCopy();
    itemCopy.collectionId = collectionId;
    itemCopy.uniqueId = uniqueId;
    return await copies.create(itemId, itemCopy);
  }

  @override
  Future<String> create(Item item, {List<List<int>> files}) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }
    if (!isNullOrWhitespace(item.getName))
      item.getId = await _generateUniqueId(item);

    await _handleFileUploads(item, files);


    return await super.create(item);
  }

  @override
  Future<String> update(String id, Item item, {List<List<int>> files}) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }
    if (!isNullOrWhitespace(item.getName)) {
      Item oldItem = (await data_sources.items.getById(id)).getOrElse(
          () => throw new NotFoundException("Item ${item} not found"));

      if (oldItem.getName.trim().toLowerCase() !=
          item.getName.trim().toLowerCase())
        item.getId = await _generateUniqueId(item);
    }

    await _handleFileUploads(item, files);

    return await super.update(id, item);
  }

//  String _handleImageLink(String value) {
//    if (value.startsWith(HOSTED_IMAGE_PREFIX)) {
//      return "${getImagesRootUrl()}${value.substring(HOSTED_IMAGE_PREFIX.length)}";
//    }
//    return value;
//  }

  @override
  Future<Map<String, String>> _validateFieldsInternal(Item item) async {
    Map<String, String> field_errors = new Map<String, String>();
    //TODO: add dynamic field validation

    if (isNullOrWhitespace(item.typeId))
      field_errors["typeId"] = "Required";
    else {
      dynamic test = await data_sources.itemTypes.getById(item.typeId);
      if (test == null) field_errors["typeId"] = "Not found";
    }

    return field_errors;
  }

  static final List<String> NON_SORTING_WORDS = ["the", "a", "an"];

  static Future<String> _generateUniqueId(Item item) async {
    if (isNullOrWhitespace(item.getName))
      throw new InvalidInputException("Name required to generate unique ID");

    StringBuffer output = new StringBuffer();
    String lastChar = "_";
    String name = item.getName.trim().toLowerCase();
    String first_word = name.split(" ")[0];
    if (NON_SORTING_WORDS.contains(first_word))
      name = name.substring(name.indexOf(" ") + 1, name.length);

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
    Option<Item> testItem = await data_sources.items.getById(base_name);
    int i = 1;
    while (testItem.isNotEmpty) {
      testName = "${base_name}_${i}";
      i++;
      testItem = await data_sources.items.getById(testName);
    }
    return testName;
  }

  Future _handleFileUploads(Item item, List<List<int>> files) async {
    ItemType type = await itemTypes.getById(item.typeId);
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

//      String image_url = getImagesRootUrl().toLowerCase();
//      if(value.toLowerCase().startsWith(image_url))
//        continue;
//      //TODO: Evaluate for abuse
//      // The server generates the image URL based on the HTTP request's server,
//      // so theoretically this should cover all real-world work cases,
//      // but if someone intentionally sent an image url from another accessible path to the server
//      // (ie, the ip address instead of domain name), it would end up downloading its own file.
//      // Since the file already exists, it would catch that it was the same file and abort,
//      // but there may be some way to abuse this. Have to think about it.

      List<int> data;

      Match m = FILE_UPLOAD_REGEX.firstMatch(value);
      if (m != null) {
        // This is a new file upload
        int filePosition = int.parse(m.group(1));
        if (files.length - 1 < filePosition) {
          throw new InvalidInputException(
              "Field ${f.getId} specifies unprovided upload file at position ${filePosition}");
        }
        data = files[filePosition];

        continue;
      } else {
        // So we assume it's a URL
        _log.fine("Processing as URL: ${value}");
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
        throw new InvalidInputException(
            "Specified file upload ${value} is empty");

      Digest hash = sha256.convert(data);
      String hashString = hash.toString();
      filesToWrite[hashString] = data;
      item.values[f.getId] = "${HOSTED_IMAGE_PREFIX}${hashString}";
    }

    // Now that the above sections have completed gathering all the file data_sources for saving, we save it all
    List<String> filesWritten = new List<String>();
    try {
      if(!ORIGINAL_IMAGE_DIR.existsSync())
        ORIGINAL_IMAGE_DIR.createSync(recursive: true);
      if(!THUMBNAIL_DIR.existsSync())
        THUMBNAIL_DIR.createSync(recursive: true);

      for (String key in filesToWrite.keys) {
        File file = new File(path.join(ORIGINAL_IMAGE_PATH, key));
        bool fileExists = await file.exists();
        if (!fileExists) {
          await file.create();
        } else  {
          int size = await file.length();
          if(size!=filesToWrite[key].length)
            throw new Exception("File already exists with a different size");
          continue;
        }

        Image image = decodeImage(filesToWrite[key]);
        List<int> thumbnailData;
        File thumbnailFile = new File(path.join(THUMBNAIL_IMAGE_PATH, key));
        if(thumbnailFile.existsSync())
          thumbnailFile.deleteSync();
        thumbnailFile.createSync();

        if(image.width>300) {
          Image thumbnail = copyResize(image, 300, -1, AVERAGE);
          thumbnailData = encodeJpg(thumbnail,quality: 90);
        } else {
          thumbnailData = filesToWrite[key];
        }

        RandomAccessFile imageRaf = await file.open(mode: FileMode.WRITE_ONLY);
        RandomAccessFile thumbnailRaf = await thumbnailFile.open(mode: FileMode.WRITE_ONLY);
        try {
          _log.fine("Writing to ${file.path}");
          imageRaf.writeFrom(filesToWrite[key]);
          filesWritten.add(file.path);
          _log.fine("Writing to ${thumbnailFile.path}");
          thumbnailRaf.writeFrom(thumbnailData);
          filesWritten.add(thumbnailFile.path);
        } finally {
          try {
            await imageRaf.close();
          } catch (e2, st) {}
          try {
            await thumbnailRaf.close();
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
