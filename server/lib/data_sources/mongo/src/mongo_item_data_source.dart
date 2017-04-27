import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dartalog_shared/global.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/data_sources/data_sources.dart';
import 'package:dartalog/data_sources/interfaces/interfaces.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:option/option.dart';
import 'a_mongo_id_data_source.dart';
import 'mongo_item_copy_data_source.dart';
import 'constants.dart';
import 'mongo_tag_data_source.dart';


class MongoItemDataSource extends AMongoIdDataSource<Item>
    with AItemDataSource {
  static final Logger _log = new Logger('MongoItemDataSource');


  final ACollectionDataSource collectionDataSource;
  MongoItemDataSource(this.collectionDataSource, MongoDbConnectionPool pool): super(pool);

  Future<Option<SelectorBuilder>> generateVisibleCriteria(
      String userUuid) async {
    final UuidDataList<Collection> collections =
        await collectionDataSource.getVisibleCollections(userUuid);
    if (collections.isEmpty) return new None<SelectorBuilder>();

    return new Some<SelectorBuilder>(
        where.oneFrom(itemCopyCollectionPath, collections.uuidList));
  }

  @override
  Future<UuidDataList<Item>> getVisible(String userUuid) async {
    return (await generateVisibleCriteria(userUuid)).cata(
        () => new UuidDataList<Item>(),
        (SelectorBuilder selector) async => await getListFromDb(selector));
  }

  @override
  Future<PaginatedUuidData<Item>> getVisiblePaginated(String userUuid,
      {int page: 0, int perPage: defaultPerPage}) async {
    return (await generateVisibleCriteria(userUuid)).cata(
        () => new PaginatedUuidData<Item>(),
        (SelectorBuilder selector) async => await getPaginatedListFromDb(
            selector,
            limit: perPage,
            offset: getOffset(page, perPage)));
  }

  @override
  Future<PaginatedUuidData<Item>> searchVisiblePaginated(
      String userUuid, String query,
      {int page: 0, int perPage: defaultPerPage}) async {
    return (await generateVisibleCriteria(userUuid)).cata(
        () => new PaginatedUuidData<Item>(),
        (SelectorBuilder selector) async => await searchPaginated(query,
            selector: selector,
            limit: perPage,
            offset: getOffset(page, perPage)));
  }

  @override
  Future<UuidDataList<Item>> searchVisible(
      String userUuid, String query) async {
    return (await generateVisibleCriteria(userUuid)).cata(
        () => new UuidDataList<Item>(),
        (SelectorBuilder selector) async =>
            await search(query, selector: selector));
  }

  @override
  Future<UuidDataList<IdNamePair>> getVisibleIdsAndNames(
      String userUuid) async {
    return (await generateVisibleCriteria(userUuid)).cata(
        () => new UuidDataList<IdNamePair>(),
        (SelectorBuilder selector) async =>
            await getIdsAndNames(selector: selector));
  }

  @override
  Future<PaginatedUuidData<IdNamePair>> getVisibleIdsAndNamesPaginated(
      String userUuid,
      {int page: 0,
      int perPage: defaultPerPage}) async {
    return (await generateVisibleCriteria(userUuid)).cata(
        () => new UuidDataList<IdNamePair>(),
        (SelectorBuilder selector) async => await getPaginatedIdsAndNames(
            selector: selector,
            limit: perPage,
            offset: getOffset(page, perPage)));
  }

  static const String dateAddedField = "dateAdded";
  static const String valuesField = "values";
  static const String dateUpdatedField = "dateUpdated";
  static const String tagsField = "tags";
  static const String fileField = "file";
  static const String fileThumbnailField = "fileThumbnail";

  @override
  Item createObject(Map<String, dynamic> data) {
    final Item output = new Item();
    AMongoIdDataSource.setIdDataFields(output, data);
    output.typeUuid = data[typeUuidField];
    output.values = data[valuesField];
    output.dateAdded = data[dateAddedField];
    output.dateUpdated = data[dateUpdatedField];
    output.file = data[fileField];
    output.fileThumbnail= data[fileThumbnailField];

    if (data[itemCopiesField] != null) {
      for (Map<dynamic,dynamic> itemCopy in data[itemCopiesField]) {
        final ItemCopy copy =
            MongoItemCopyDataSource.staticCreateObject(itemCopy);
        copy.itemUuid = output.uuid;
        output.copies.add(copy);
      }
    }

    if(data[tagsField]!=null) {
      output.tags = <Tag>[];
      for (Map<dynamic,dynamic> tag in data[tagsField]) {
        final Tag newTag = MongoTagDataSource.staticCreateObject(tag);
        output.tags.add(newTag);
      }
    }

    return output;
  }

  @override
  Future<DbCollection> getCollection(MongoDatabase con) =>
      con.getItemsCollection();

  @override
  void updateMap(Item item, Map<String, dynamic> data) {
    super.updateMap(item, data);
    data[typeUuidField] = item.typeUuid;
    data[valuesField] = item.values;
    if (item.dateAdded != null) data[dateAddedField] = item.dateAdded;
    data[dateUpdatedField] = item.dateUpdated;
    data[fileField] = item.file;
    data[fileThumbnailField] = item.fileThumbnail;
    if(item.tags!=null) {
      final List<dynamic> tagsList = new List<dynamic>();
      for(Tag tag in item.tags) {
        final Map<dynamic,dynamic> tagMap = <dynamic,dynamic>{};
        MongoTagDataSource.staticUpdateMap(tag, tagMap);
        tagsList.add(tagMap);
      }
    data[tagsField] = tagsList;
  }
  }
}
