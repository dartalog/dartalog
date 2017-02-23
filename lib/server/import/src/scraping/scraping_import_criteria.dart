import 'package:logging/logging.dart';
import 'package:dartalog/tools.dart';
import 'package:html/dom.dart';

class ScrapingImportCriteria {
  static final Logger _log = new Logger('ScrapingImportCriteria');

  static const String innerHtml = "innerHtml";
  static const String innerText = "innerText";

  final String field;
  final String elementSelector;
  final String elementAttribute;
  final int elementIndex;

  final bool trimValues;

  final String contentsRegex;
  RegExp _contentsRegex;
  final bool contentsRegexCaseSensitive;
  final bool contentsRegexMultiline;
  final int contentsRegexGroup;

  final Map<String, String> replaceRegex;
  final Map<RegExp, String> _replaceRegex = new Map<RegExp, String>();

  List<String> acceptedValues;

  final bool multipleValues;

  ScrapingImportCriteria(
      {this.field,
      this.elementSelector,
      this.elementAttribute,
      this.elementIndex: -1,
      this.multipleValues: false,
      this.trimValues: true,
      this.contentsRegex,
      this.contentsRegexGroup: 0,
      this.contentsRegexCaseSensitive: false,
      this.contentsRegexMultiline: true,
      this.replaceRegex,
      this.acceptedValues: null}) {
    if (!StringTools.isNullOrWhitespace(contentsRegex)) {
      _contentsRegex = new RegExp(contentsRegex,
          multiLine: this.contentsRegexMultiline,
          caseSensitive: this.contentsRegexCaseSensitive);
    }
    if (this.replaceRegex != null) {
      for (String regex in this.replaceRegex.keys) {
        this._replaceRegex[new RegExp(regex)] = this.replaceRegex[regex];
      }
    }
  }

  List<String> _getFieldValueInternal(Element ele) {
    String data;
    if (!StringTools.isNullOrWhitespace(elementAttribute)) {
      switch (elementAttribute) {
        case innerHtml:
          data = ele.innerHtml;
          break;
        case innerText:
          data = ele.text;
          break;
        default:
          if (!ele.attributes.containsKey(elementAttribute) ||
              StringTools.isNullOrWhitespace(ele.attributes[elementAttribute]))
            return <String>[];
          data = ele.attributes[elementAttribute];
          break;
      }
    } else {
      data = ele.text;
    }
    return this._getRegexValues(data);
  }

  List<String> getFieldValues(Document doc) {
    final List<String> output = new List<String>();
    if (!StringTools.isNullOrWhitespace(elementSelector)) {
      _log.fine("Using element selector $elementSelector");
      final List<Element> elements = doc.querySelectorAll(this.elementSelector);
      _log.fine("${elements.length} elements found");
      if (elementIndex >= 0) {
        _log.fine("Element index $elementIndex specified");
        if (elements.length - 1 >= elementIndex)
          output.addAll(_getFieldValueInternal(elements[elementIndex]));
      } else {
        _log.fine("Element index not specified, getting all elements");
        for (Element ele in elements) {
          output.addAll(_getFieldValueInternal(ele));
          if (!multipleValues && output.length > 0) break;
        }
      }
    } else if (this._contentsRegex != null) {
      _log.fine(
          "Element selector not specified, performing global regex search");
      // Element selector not specified, global search yay for performance killers
      output.addAll(this._getRegexValues(doc.outerHtml));
    } else {
      throw new Exception(
          "Import field critieria does not specify elementSelector or contentsRegex, nothing to search for");
    }

    if (trimValues) {
      for (int i = 0; i < output.length; i++) {
        output[i] = output[i].trim();
      }
    }
    _log.fine("Found values: ${output.join(',')}");

    return output;
  }

  List<String> _getRegexValues(String data) {
    final List<String> output = new List<String>();

    if (this._contentsRegex == null) {
      output.add(data);
    } else {
      final Iterable<Match> matches = this._contentsRegex.allMatches(data);
      if (matches != null) {
        for (Match m in matches) {
          output.add(m.group(this.contentsRegexGroup));
        }
      }
    }

    for (RegExp regex in this._replaceRegex.keys) {
      for (int i = 0; i < output.length; i++) {
        output[i] = output[i].replaceAll(regex, this._replaceRegex[regex]);
      }
    }

    if (this.acceptedValues != null)
      output.removeWhere(
          (String value) => !this.acceptedValues.contains((value)));

    if (!multipleValues && output.length > 1) return <String>[output[0]];

    return output;
  }
}
