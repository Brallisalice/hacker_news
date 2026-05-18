import 'package:html/parser.dart' as html_parser;

class TextFormatter {
  static String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }
}
