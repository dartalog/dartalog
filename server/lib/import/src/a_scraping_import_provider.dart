import 'a_import_provider.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/import/src/scraping/scraping_import_criteria.dart';
import 'dart:async';
import 'import_result.dart';
import 'package:html/dom.dart';
import 'package:dartalog/data_sources/data_sources.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:option/option.dart';
import 'package:dartalog/data/data.dart';
import 'package:html/parser.dart' show parse;

abstract class AScrapingImportProvider extends AImportProvider {
  static final Logger _log = new Logger('AScrapingImportProvider');

  String get importProviderName;
  String getItemURL(String id);
  List<ScrapingImportCriteria> get itemTypeCriteria;
  List<ScrapingImportCriteria> get fieldCriteria;

  final AItemTypeDataSource itemTypeDataSource;

  AScrapingImportProvider(this.itemTypeDataSource);

  @override
  Future<ImportResult> import(String id) async {
    final String itemUrl = getItemURL(id);

    final ImportResult output = new ImportResult();
    output.itemUrl = itemUrl;
    output.itemId = id;
    output.itemSource = importProviderName;

    final String contents =
        await this.downloadPage(itemUrl, stripNewlines: true);

    final Document doc = parse(contents);

    final List<String> itemTypes =
        (await itemTypeDataSource.getAllIdsAndNames()).uuidList;

    _log.fine("Attempting to determine item type");
    for (ScrapingImportCriteria criteria in itemTypeCriteria) {
      criteria.acceptedValues = itemTypes;
      final List<String> values = criteria.getFieldValues(doc);
      for (String value in values) {
        if (!StringTools.isNullOrWhitespace(value)) {
          final Option<ItemType> itemTypeOpt =
              await itemTypeDataSource.getByUuid(value);
          itemTypeOpt.map((ItemType itemType) {
            _log.fine(("Item type determined to be ${itemType.uuid}"));
            output.itemTypeId = itemType.uuid;
            output.itemTypeName = itemType.name;
          });

          if (!StringTools.isNullOrWhitespace(output.itemTypeId)) {
            break;
          }
        }
      }

      if (!StringTools.isNullOrWhitespace(output.itemTypeId)) break;
    }

    if (StringTools.isNullOrWhitespace(output.itemTypeId))
      _log.fine(("Item type could not be determined"));

    for (ScrapingImportCriteria field in fieldCriteria) {
      final List<String> values = field.getFieldValues(doc);
      if (values.length > 0)
        output.values[field.field] = field.getFieldValues(doc);
    }

    return output;
  }
}
