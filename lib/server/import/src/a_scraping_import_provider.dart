import 'a_import_provider.dart';
import 'package:logging/logging.dart';
import 'package:dartalog/server/import/src/scraping/scraping_import_criteria.dart';
import 'dart:async';
import 'import_result.dart';
import 'package:html/dom.dart';
import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/tools.dart';
import 'package:option/option.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:html/parser.dart' show parse;

abstract class AScrapingImportProvider extends AImportProvider {
  static final Logger _log = new Logger('AScrapingImportProvider');

  String get importProviderName;
  String getItemURL(String id);
  List<ScrapingImportCriteria> get itemTypeCriteria;
  List<ScrapingImportCriteria> get fieldCriteria;

  Future<ImportResult> import(String id) async {
    String itemUrl = getItemURL(id);

    ImportResult output = new ImportResult();
    output.itemUrl = itemUrl;
    output.itemId = id;
    output.itemSource = importProviderName;

    String contents = await this.downloadPage(itemUrl, stripNewlines: true);

    Document doc = parse(contents);

    List itemTypes = (await data_sources.itemTypes.getAllIdsAndNames()).idList;

    _log.fine("Attempting to determine item type");
    for (ScrapingImportCriteria criteria in itemTypeCriteria) {
      criteria.acceptedValues = itemTypes;
      List<String> values = criteria.getFieldValues(doc);
      for (String value in values) {
        if (!StringTools.isNullOrWhitespace(value)) {
          Option<ItemType> itemTypeOpt =
              await data_sources.itemTypes.getById(value);
          itemTypeOpt.map((ItemType itemType) {
            _log.fine(("Item type determined to be ${itemType.id}"));
            output.itemTypeId = itemType.id;
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
      List<String> values = field.getFieldValues(doc);
      if (values.length > 0)
        output.values[field.field] = field.getFieldValues(doc);
    }

    return output;
  }
}
