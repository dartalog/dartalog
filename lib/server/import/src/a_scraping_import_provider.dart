part of import;

abstract class AScrapingImportProvider extends AImportProvider {

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

    for(ScrapingImportCriteria criteria in itemTypeCriteria) {
      List<String> values = criteria.getFieldValues(doc);
      for(String value in values) {
        if(!isNullOrWhitespace(value)) {
          Option<ItemType> itemTypeOpt = await data_sources.itemTypes.getById(value);
          itemTypeOpt.map((ItemType itemType) {
            output.itemTypeId = itemType.id;
            output.itemTypeName = itemType.name;
          });
          if(!isNullOrWhitespace(output.itemTypeId))
            break;
        }
      }

      if(!isNullOrWhitespace(output.itemTypeId))
        break;
    }

    for(ScrapingImportCriteria field in fieldCriteria) {
      List<String> values = field.getFieldValues(doc);
      if(values.length>0)
        output.values[field.field] = field.getFieldValues(doc);
    }

    return output;
  }
}