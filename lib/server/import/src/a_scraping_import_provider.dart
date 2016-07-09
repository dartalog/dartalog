part of import;

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

    String contents = await this._downloadPage(itemUrl, stripNewlines: true);

    Document doc = parse(contents);

    List itemTypes = (await data_sources.itemTypes.getAllIdsAndNames()).idList;

    _log.fine("Attempting to determine item type");
    for(ScrapingImportCriteria criteria in itemTypeCriteria) {
      criteria.acceptedValues = itemTypes;
      List<String> values = criteria.getFieldValues(doc);
      for(String value in values) {
        if(!isNullOrWhitespace(value)) {

          Option<ItemType> itemTypeOpt = await data_sources.itemTypes.getById(value);
          itemTypeOpt.map((ItemType itemType) {
            _log.fine(("Item type determined to be ${itemType.id}"));
            output.itemTypeId = itemType.id;
            output.itemTypeName = itemType.name;
          });

          if(!isNullOrWhitespace(output.itemTypeId)) {
            break;
          }
        }
      }

      if(!isNullOrWhitespace(output.itemTypeId))
        break;
    }

    if(isNullOrWhitespace(output.itemTypeId))
      _log.fine(("Item type could not be determined"));

    for(ScrapingImportCriteria field in fieldCriteria) {
      List<String> values = field.getFieldValues(doc);
      if(values.length>0)
        output.values[field.field] = field.getFieldValues(doc);
    }

    return output;
  }
}