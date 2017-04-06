import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:option/option.dart';
import 'package:image/image.dart';
import 'package:dartalog/tools.dart';
import 'package:dartalog/global.dart';
import 'package:dartalog/server/server.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:dartalog/server/data_sources/interfaces/interfaces.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'a_id_name_based_model.dart';
import 'item_copy_model.dart';
import 'package:dartalog/server/model/model.dart';
import 'a_file_upload_model.dart';

class ItemModel extends AIdNameBasedModel<Item> with AFileUploadModel<Item> {
  static final Logger _log = new Logger('ItemModel');
  static final RegExp legalIdCharacters = new RegExp("[a-zA-Z0-9_\-]");

  static final String originalImagePath =
      path.join(rootDirectory, hostedImagesOriginalsPath);

  static final String thumbnailImagePath =
      path.join(rootDirectory, hostedImagesThumbnailsPath);

  static final Directory originalImageDir =
      new Directory(originalImagePath);

  static final Directory thumbnailDir = new Directory(thumbnailImagePath);
  static final List<String> nonSortingWords = <String>["the", "a", "an"];

  // TODO: evaluate more (oh)
  final ItemCopyModel copies = new ItemCopyModel();
  @override
  AItemDataSource get dataSource => data_sources.items;

  @override
  Logger get loggerImpl => _log;

  @override
  String get defaultReadPrivilegeRequirement => UserPrivilege.none;
  @override
  String get defaultWritePrivilegeRequirement => UserPrivilege.curator;
  @override
  String get defaultDeletePrivilegeRequirement => UserPrivilege.admin;

//  @override
//  _performAdjustments(Item item) {
//    // TODO: filter this down to just image fields?
//    for(String key in item.values.keys) {
//      item.values[key] = _handleImageLink(item.values[key]);
//    }
//  }

  Future<PaginatedUuidData<IdNamePair>> getVisibleIdsAndNames(
      {int page: 0, int perPage: defaultPerPage}) async {
    if (page < 0) {
      throw new InvalidInputException("Page must be a non-negative number");
    }
    if (perPage < 0) {
      throw new InvalidInputException("Per-page must be a non-negative number");
    }
    await validateGetAllIdsAndNamesPrivileges();
    return await dataSource.getVisibleIdsAndNamesPaginated(this.currentUserUuid,
        page: page, perPage: perPage);
  }

  Future<PaginatedUuidData<Item>> getVisible(
      {int page: 0, int perPage: defaultPerPage}) async {
    if (page < 0) {
      throw new InvalidInputException("Page must be a non-negative number");
    }
    if (perPage < 0) {
      throw new InvalidInputException("Per-page must be a non-negative number");
    }
    await validateGetAllIdsAndNamesPrivileges();
    return await dataSource.getVisiblePaginated(this.currentUserUuid,
        page: page, perPage: perPage);
  }

  Future<PaginatedUuidData<Item>> searchVisible(String query,
      {int page: 0, int perPage: defaultPerPage}) async {
    if (page < 0) {
      throw new InvalidInputException("Page must be a non-negative number");
    }
    if (perPage < 0) {
      throw new InvalidInputException("Per-page must be a non-negative number");
    }
    await validateGetAllIdsAndNamesPrivileges();
    return await dataSource.searchVisiblePaginated(this.currentUserUuid, query,
        page: page, perPage: perPage);
  }

  @override
  Future<String> create(Item item,
          {List<List<int>> files, bool bypassAuthentication: false, bool keepUuid: false}) =>
      throw new InvalidInputException("Use createWithCopy");

  Future<String> createWithCopy(Item item, String collectionUuid,
      {String uniqueId, List<List<int>> files}) async {
    await validateCreatePrivileges();

    item.uuid = generateUuid();
    item.dateAdded = new DateTime.now();
    item.dateUpdated = new DateTime.now();
    if (!StringTools.isNullOrWhitespace(item.name))
      item.readableId = await _generateUniqueReadableId(item);

    final ItemCopy itemCopy = new ItemCopy();
    itemCopy.collectionUuid = collectionUuid;
    itemCopy.uniqueId = uniqueId;
    itemCopy.status = ItemStatus.defaultStatus;

    await DataValidationException.performValidation((Map<String,String> output) async {
      output.addAll(await validateFields(item));
      output
          .addAll(await copies.validateFields(itemCopy, skipItemIdCheck: true));
    });

    await _handleFileUploads(item, files);
    //TODO: More thorough cleanup of files in case of failure

    final String itemId = await data_sources.items.create(item.uuid, item);
    itemCopy.itemUuid = itemId;
    await copies.create(itemCopy);
    return itemId;
  }

  @override
  Future<Item> getByUuidOrReadableId(String uuidOrReadableId, {bool includeType: false,
  bool includeFields: false,
  bool includeCopies: false,
  bool includeCopyCollection: false}) async {
    if(isUuid(uuidOrReadableId)) {
      return getByUuid(uuidOrReadableId, includeType: includeType, includeFields: includeFields, includeCopies: includeCopies, includeCopyCollection: includeCopyCollection);
    } else {
      return getByReadableId(uuidOrReadableId, includeType: includeType, includeFields: includeFields, includeCopies: includeCopies, includeCopyCollection: includeCopyCollection);
    }
  }


  @override
  Future<Item> getByUuid(String uuid,
      {bool includeType: false,
      bool includeFields: false,
      bool includeCopies: false,
      bool includeCopyCollection: false,
      bool bypassAuthentication: false}) async {
    await validateGetPrivileges();

    final Item output = await super.getByUuid(uuid, bypassAuthentication: bypassAuthentication);

    await prepareOutput(output, includeType: includeType, includeFields: includeFields, includeCopies: includeCopies, includeCopyCollection: includeCopyCollection);

    return output;
  }

  @override
  Future<Item> getByReadableId(String readableId,
      {bool includeType: false,
        bool includeFields: false,
        bool includeCopies: false,
        bool includeCopyCollection: false,
        bool bypassAuth: false}) async {
    await validateGetPrivileges();

    final Item output = await super.getByReadableId(readableId, bypassAuth: bypassAuth);

    await prepareOutput(output, includeType: includeType, includeFields: includeFields, includeCopies: includeCopies, includeCopyCollection: includeCopyCollection);

    return output;
  }


  Future<Null> prepareOutput(Item output, {bool includeType: false,
    bool includeFields: false,
    bool includeCopies: false,
    bool includeCopyCollection: false,}) async {

    final String uuid = output.uuid;

    if (includeType) {
      output.type = (await data_sources.itemTypes.getByUuid(output.typeUuid))
          .getOrElse(() => throw new Exception(
          "Item type '${output.typeUuid}' specified for item not found"));

      if (includeFields) {
        output.type.fields =
        await data_sources.fields.getByUuids(output.type.fieldUuids);
      }
    } else if (includeFields) {
      throw new InvalidInputException(
          "Cannot include fields without including the type");
    }
    if (includeCopies) {
      if (output.copies == null) {
        output.copies = await this
            .copies
            .getVisibleForItem(uuid, includeCollection: includeCopyCollection);
      }
    } else {
      output.copies = null;
    }
    try {
      await validateUpdatePrivileges(uuid);
      output.canEdit = true;
    } catch (e) {
      output.canEdit = false;
    }
    try {
      await validateDeletePrivileges(uuid);
      output.canDelete = true;
    } catch (e) {
      output.canDelete = false;
    }

    return output;
  }

  @override
  Future<String> update(String uuid, Item item, {List<List<int>> files, bool bypassAuthentication: false}) async {
    if(!bypassAuthentication)
      await validateUpdatePrivileges(uuid);

    item.dateAdded = null;
    item.dateUpdated = new DateTime.now();

    if (!StringTools.isNullOrWhitespace(item.name)) {
      final Item oldItem = (await data_sources.items.getByUuid(uuid))
          .getOrElse(() => throw new NotFoundException("Item $uuid not found"));

      if (oldItem.name.trim().toLowerCase() != item.name.trim().toLowerCase())
        item.readableId = await _generateUniqueReadableId(item);
    }

    await _handleFileUploads(item, files);

    return await super.update(uuid, item, bypassAuthentication: bypassAuthentication);
  }

  Future<Null> _handleFileUploads(Item item, List<List<int>> files) async {
    final ItemType type = await itemTypes.getByUuid(item.typeUuid);
    final List<Field> fields =
        await data_sources.fields.getByUuids(type.fieldUuids);
    final Map<String, List<int>> filesToWrite = new Map<String, List<int>>();

    for (Field f in fields) {
      if (f.type != "image" ||
          !item.values.containsKey(f.uuid) ||
          StringTools.isNullOrWhitespace(item.values[f.uuid])) continue;

      //TODO: Old image cleanup

      final String value = item.values[f.uuid];

      if (value.startsWith(hostedImagesPrefix)) {
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

      final Match m = fileUploadRegex.firstMatch(value);
      if (m != null) {
        // This is a new file upload
        final int filePosition = int.parse(m.group(1));
        if (files.length - 1 < filePosition) {
          throw new InvalidInputException(
              "Field ${f.uuid} specifies unprovided upload file at position $filePosition");
        }
        data = files[filePosition];
      } else {
        // So we assume it's a URL
        _log.fine("Processing as URL: $value");
        final Uri fileUri = Uri.parse(value);
        final HttpClientRequest req = await new HttpClient().getUrl(fileUri);
        final HttpClientResponse response = await req.close();
        final List<List<int>> output = await response.toList();
        data = new List<int>();
        for (List<int> chunk in output) {
          data.addAll(chunk);
        }
      }

      if (data.length == 0)
        throw new InvalidInputException(
            "Specified file upload $value is empty");

      final Digest hash = sha256.convert(data);
      final String hashString = hash.toString();
      filesToWrite[hashString] = data;
      item.values[f.uuid] = "$hostedImagesPrefix$hashString";
    }

    // Now that the above sections have completed gathering all the file services for saving, we save it all
    final List<String> filesWritten = new List<String>();
    try {
      if (!originalImageDir.existsSync())
        originalImageDir.createSync(recursive: true);
      if (!thumbnailDir.existsSync())
        thumbnailDir.createSync(recursive: true);

      for (String key in filesToWrite.keys) {
        final File file = new File(path.join(originalImagePath, key));
        final bool fileExists = await file.exists();
        if (!fileExists) {
          await file.create();
        } else {
          final int size = await file.length();
          if (size != filesToWrite[key].length)
            throw new Exception("File already exists with a different size");
          continue;
        }

        final Image image = decodeImage(filesToWrite[key]);
        List<int> thumbnailData;
        final File thumbnailFile =
            new File(path.join(thumbnailImagePath, key));
        if (thumbnailFile.existsSync()) thumbnailFile.deleteSync();
        thumbnailFile.createSync();

        if (image.width > 300) {
          final Image thumbnail = copyResize(image, 300, -1, AVERAGE);
          thumbnailData = encodeJpg(thumbnail, quality: 90);
        } else {
          thumbnailData = filesToWrite[key];
        }

        final RandomAccessFile imageRaf =
            await file.open(mode: FileMode.WRITE_ONLY);
        final RandomAccessFile thumbnailRaf =
            await thumbnailFile.open(mode: FileMode.WRITE_ONLY);
        try {
          _log.fine("Writing to ${file.path}");
          await imageRaf.writeFrom(filesToWrite[key]);
          filesWritten.add(file.path);
          _log.fine("Writing to ${thumbnailFile.path}");
          await thumbnailRaf.writeFrom(thumbnailData);
          filesWritten.add(thumbnailFile.path);
        } finally {
          try {
            await imageRaf.close();
          } catch (e2) {}
          try {
            await thumbnailRaf.close();
          } catch (e2) {}
        }
      }
    } catch (e, st) {
      _log.severe(e.message, e, st);
      for (String f in filesWritten) {
        try {
          final File file = new File(f);
          final bool exists = await file.exists();
          if (exists) await file.delete();
        } catch (e) {}
      }
      throw e;
    }
  }

  @override
  Future<Null> validateFieldsInternal(
      Map<String, String> fieldErrors, Item item,
      {String existingId: null}) async {
    //TODO: add dynamic field validation
    if (StringTools.isNullOrWhitespace(item.typeUuid))
      fieldErrors["typeUuid"] = "Required";
    else {
      final dynamic test = await data_sources.itemTypes.getByUuid(item.typeUuid);
      if (test == null) fieldErrors["typeUuid"] = "Not found";
    }
  }

  static Future<String> _generateUniqueReadableId(Item item) async {
    if (StringTools.isNullOrWhitespace(item.name))
      throw new InvalidInputException("Name required to generate unique ID");

    final StringBuffer output = new StringBuffer();
    String lastChar = "_";
    String name = item.name.trim().toLowerCase();
    final String firstWord = name.split(" ")[0];
    if (nonSortingWords.contains(firstWord))
      name = name.substring(name.indexOf(" ") + 1, name.length);

    for (int i = 0; i < name.length; i++) {
      final String char = name.substring(i, i + 1);
      switch (char) {
        case " ":
        case ":":
          if (lastChar != "_") {
            lastChar = "_";
            output.write(lastChar);
          }
          break;
        default:
          if (legalIdCharacters.hasMatch(char)) {
            lastChar = char.toLowerCase();
            output.write(lastChar);
          }
          break;
      }
    }

    if (output.length == 0)
      throw new InvalidInputException(
          "Could not generate safe ID from name '${item.name}'");

    final String baseName = output.toString();
    String testName = baseName;
    Option<Item> testItem = await data_sources.items.getByReadableId(baseName);
    int i = 1;
    while (testItem.isNotEmpty) {
      testName = "${baseName}_$i";
      i++;
      testItem = await data_sources.items.getByReadableId(testName);
    }
    return testName;
  }
}
