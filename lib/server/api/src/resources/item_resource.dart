part of api;

class ItemResource extends AResource {
  static final Logger _log = new Logger('ItemResource');
  static final RegExp LEGAL_ID_CHARACTERS = new RegExp("[a-zA-Z0-9_]");

  Logger get _logger => _log;

  @ApiMethod(method: 'POST', path: '${API_ITEMS_PATH}/')
  Future<IdResponse> create(Item item) async {
    try {
      await item.validate(true);
      if (isNullOrWhitespace(item.id)) item.id = await _generateUniqueId(item);

      String output = await model.items.write(item);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'POST', path: '${API_ITEMS_PATH}/{id}/${API_COPIES_PATH}/')
  Future<IdResponse> createCopy(String id, ItemCopy itemCopy) async {
    try {
      itemCopy.itemId = id;
      Item item = await model.items.getById(id);

      if (item == null) {
        throw new NotFoundError("Item '${id}' not found");
      }
      itemCopy.copy = item.copyCount + 1;
      itemCopy.validate(true);
      item.copyCount = itemCopy.copy;
      await model.items.write(item, id);

      String output = await model.itemCopies.write(itemCopy);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'DELETE', path: '${API_ITEMS_PATH}/{id}/')
  Future<VoidMessage> delete(String id) async {
    try {
      await model.items.delete(id);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_ITEMS_PATH}/')
  Future<List<ItemListing>> getAllListings() async {
    try {
      List<Item> output = await model.items.getAll();
      return ItemListing.convertList(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_ITEMS_PATH}/{id}/')
  Future<Item> getById(String id, {String expand}) async {
    try {
      Item output = await model.items.getById(id);

      if (output == null) {
        throw new NotFoundError("Item '${id}' not found");
      }

      if (!isNullOrWhitespace(expand)) {
        List<String> expands = expand.split(",");
        if (expands.contains("type")) {
          output.type = await model.itemTypes.getById(output.typeId);
          if (output.type == null) {
            throw new InternalServerError(
                "Item type '${output.typeId}' specified for item not found");
          }
          if (expands.contains("type.fields")) {
            output.type.fields =
                await model.fields.getByIds(output.type.fieldIds);
          }
        }
        if (expands.contains("copies")) {
          output.copies = await model.itemCopies.getAllForItemId(id);
        }
      }
      return output;
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(path: '${API_ITEMS_PATH}/{id}/${API_COPIES_PATH}/')
  Future<List<ItemCopy>> getCopiesForId(String id) async {
    try {
      return await model.itemCopies.getAllForItemId(id);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(method: 'PUT', path: '${API_ITEMS_PATH}/{id}/')
  Future<IdResponse> update(String id, Item item) async {
    try {
      await item.validate(id != item.id);
      String output = await model.items.write(item, id);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  @ApiMethod(
      method: 'PUT', path: '${API_ITEMS_PATH}/{id}/${API_COPIES_PATH}/{copy}/')
  Future<IdResponse> updateCopy(String id, int copy, ItemCopy itemCopy) async {
    try {
      itemCopy.validate(false);

      String output = await model.itemCopies.write(itemCopy, id, copy);
      return new IdResponse.fromId(output);
    } catch (e, st) {
      _HandleException(e, st);
    }
  }

  String _generateRedirect(String newId) =>
      "${SERVER_API_ROOT}${API_ITEMS_PATH}/${newId}";

  Logger _GetLogger() {
    return _log;
  }

  Future _handleFileUploads(Item item) async {
    ItemType type = await model.itemTypes.getById(item.typeId);
    List<Field> fields = await model.fields.getByIds(type.fieldIds);
    Map<String, List<int>> filesToWrite = new Map<String, List<int>>();

    for (Field f in fields) {
      if (f.type != "image" ||
          !item.values.containsKey(f.id) ||
          isNullOrWhitespace(item.values[f.id])) continue;

      //TODO: Old image cleanup

      String value = item.values[f.id];

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
          throw new BadRequestError("Field ${f
              .id} specifies unprovided upload file at position ${filePosition}");
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
        throw new BadRequestError("Specified file upload ${value} is empty");

      crypto.Digest hash = crypto.sha256.convert(data);
      String hashString = hash.toString();
      filesToWrite[hashString] = data;
      item.values[f.id] = "${HOSTED_IMAGE_PREFIX}${hashString}";
    }

    // Now that the above sections have completed gathering all the file data for saving, we save it all
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

  static Future<String> _generateUniqueId(Item item) async {
    if (isNullOrWhitespace(item.name))
      throw new model.InvalidInputException(
          "Name required to generate unique ID");

    StringBuffer output = new StringBuffer();
    String lastChar = "_";
    for (int i = 0; i < item.name.length; i++) {
      String char = item.name.substring(i, i + 1);
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
      throw new model.InvalidInputException(
          "Could not generate safe ID from name '${item.name}'");

    String base_name = output.toString();
    String testName = base_name;
    Item testItem = await model.items.getById(base_name);
    int i = 1;
    while (testItem != null) {
      testName = "${base_name}_${i}";
      i++;
      testItem = await model.items.getById(testName);
    }
    return testName;
  }
}
