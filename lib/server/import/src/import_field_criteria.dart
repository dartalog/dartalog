part of import;

class ImportFieldCriteria {
  String field;
  String elementSelector;
  String elementAttribute;

  String contentsRegex;
  int contentsRegexGroup = 0;

  ImportFieldCriteria({this.field, this.elementSelector, this.elementAttribute, this.contentsRegex, this.contentsRegexGroup}) {

  }

  List<String> getFieldValues(Document doc) {

  }
}