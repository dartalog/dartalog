part of import;

abstract class AScrapingImportProvider extends AImportProvider {

  String _getImportProviderName();
  String _getItemURL(String id);
  List<ImportFieldCriteria> _getFieldCriteria();

  Future<ImportResult> import(String id) async {
    String itemUrl = _getItemURL(id);

    ImportResult output = new ImportResult();
    output.itemUrl = itemUrl;
    output.itemId = id;
    output.itemSource = _getImportProviderName();

    String contents = await this._downloadPage(itemUrl, stripNewlines: true);

    Document doc = parse(contents);

    for(ImportFieldCriteria field in _getFieldCriteria()) {
      output.values[field.field] = field.getFieldValues(doc);
    }

    return output;
  }
}