part of import;

class ImportFieldCriteria {
  String field;
  String elementSelector;
  String elementAttribute;

  String contentsRegex;
  int contentsRegexGroup = 0;

  ImportFieldCriteria({this.field, this.elementSelector, this.elementAttribute, this.contentsRegex, this.contentsRegexGroup}) {

  }

  String getFieldValue(Document doc) {

  }
}